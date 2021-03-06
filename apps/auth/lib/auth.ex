defmodule Auth do
  @moduledoc """
  This module contains the logic of authentication using Ueberauth.
  The primary function is `get_or_register/3`.
  """
  alias Auth.User
  alias Auth.Authorization
  alias Ueberauth.Auth, as: UAuth

  @doc """
  Get a User from authorization, register the user if not found.
  """
  def get_or_register(auth, current_user, repo) do
    case auth_and_validate(auth, repo) do
      {:error, :not_found} -> register_user_from_auth(auth, current_user, repo)
      {:error, reason} -> {:error, reason}
      authorization ->
        if authorization.expires_at &&
           authorization.expires_at < Guardian.Utils.timestamp do
          replace_authorization(authorization, auth, current_user, repo)
        else
          user_from_authorization(authorization, current_user, repo)
        end
    end
  end

  defp validate_auth_for_registration(%UAuth{provider: :identity} = auth) do
    password = Map.get(auth.credentials.other, :password)
    password_confirmation = Map.get(auth.credentials.other,
      :password_confirmation)
    with :ok <- validate_password_confirmation(password, password_confirmation),
         :ok <- validate_password_length(password) do
         validate_email(auth.info.email)
    end
  end

  defp validate_auth_for_registration(_auth), do: :ok

  defp validate_password_confirmation(password, password_confirmation) do
    case password do
      nil -> {:error, :password_is_null}
      "" -> {:error, :password_empty}
      ^password_confirmation -> :ok
      _ -> {:error, :password_confirmation_does_not_match}
    end
  end

  defp validate_password_length(password) when is_binary(password) do
    if String.length(password) >= 8 do
      :ok
    else
      {:error, :password_length_is_less_than_8}
    end
  end

  defp validate_email(email) when is_binary(email) do
    email_pattern = ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    case Regex.run(email_pattern, email) do
      nil -> {:error, :invalid_email}
      [_email] -> :ok
    end
  end

  defp register_user_from_auth(auth, current_user, repo) do
    with :ok <- validate_auth_for_registration(auth),
         {:ok, response} <- repo.transaction(fn ->
            create_user_from_auth(auth, current_user, repo) end)
    do
      response
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp replace_authorization(authorization, auth, current_user, repo) do
    with :ok <- validate_auth_for_registration(auth),
      {:ok, user} <- user_from_authorization(authorization, current_user, repo)
    do
      repo.transaction(fn ->
        repo.delete(authorization)
        authorization_from_auth(user, auth, repo)
        user
      end)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp user_from_authorization(authorization, current_user, repo) do
    case repo.one(Ecto.assoc(authorization, :user)) do
      nil -> {:error, :user_not_found}
      user ->
        if current_user && current_user.id != user.id do
          {:error, :user_does_not_match}
        else
          {:ok, user}
        end
    end
  end

  defp create_user_from_auth(auth, current_user, repo) do
    user = current_user
      || repo.get_by(User, email: auth.info.email)
      || create_user(auth, repo)
    authorization_from_auth(user, auth, repo)
    {:ok, user}
  end

  defp create_user(auth, repo) do
    name = name_from_auth(auth)
    result = User.registration_changeset(%User{},
      scrub(%{email: auth.info.email, name: name}))
    case repo.insert(result) do
      {:ok, user} -> user
      {:error, reason} -> repo.rollback(reason)
    end
  end

  defp auth_and_validate(%{provider: :identity} = auth, repo) do
    case repo.get_by(Authorization, uid: uid_from_auth(auth),
      provider: to_string(auth.provider)) do
      nil -> {:error, :not_found}
      authorization ->
        case auth.credentials.other.password do
          pass when is_binary(pass) ->
            if Comeonin.Bcrypt.checkpw(
                auth.credentials.other.password, authorization.token) do
              authorization
            else
              {:error, :password_does_not_match}
            end
          _ -> {:error, :password_required}
        end
    end
  end

  defp auth_and_validate(auth, repo) do
    case repo.get_by(Authorization, uid: uid_from_auth(auth),
                                    provider: to_string(auth.provider)) do
      nil -> {:error, :not_found}
      authorization ->
        if authorization.token == auth.credentials.token do
          authorization
        else
          {:error, :token_mismatch}
        end
    end
  end

  defp authorization_from_auth(user, auth, repo) do
    authorization = Ecto.build_assoc(user, :authorizations)
    changeset = Authorization.changeset(
      authorization,
      scrub(
        %{
          provider: to_string(auth.provider),
          uid: uid_from_auth(auth),
          token: token_from_auth(auth),
          refresh_token: auth.credentials.refresh_token,
          expires_at: auth.credentials.expires_at,
          password: password_from_auth(auth),
          password_confirmation: password_confirmation_from_auth(auth)
        }
      )
    )
    case repo.insert(changeset) do
      {:ok, the_auth} -> the_auth
      {:error, reason} -> repo.rollback(reason)
    end
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and String.strip(&1) != ""))
      |> Enum.join(" ")
    end
  end

  defp token_from_auth(%{provider: :identity} = auth) do
    case auth do
      %{credentials: %{other: %{password: pass}}} when not is_nil(pass) ->
        Comeonin.Bcrypt.hashpwsalt(pass)
      _ -> nil
    end
  end

  defp token_from_auth(auth), do: auth.credentials.token

  defp uid_from_auth(auth), do: auth.uid

  defp password_from_auth(%{provider: :identity} = auth),
    do: auth.credentials.other.password
  defp password_from_auth(_), do: nil

  defp password_confirmation_from_auth(%{provider: :identity} = auth) do
    auth.credentials.other.password_confirmation
  end
  defp password_confirmation_from_auth(_), do: nil

  # We don't have any nested structures in our params that we are using scrub
  # with so this is a very simple scrub
  defp scrub(params) do
    result = Enum.filter(params, fn
      {_key, val} when is_binary(val) -> String.strip(val) != ""
      {_key, val} when is_nil(val) -> false
      _ -> true
    end)
    result |> Enum.into(%{})
  end
end
