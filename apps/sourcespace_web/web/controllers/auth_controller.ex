defmodule SourceSpaceWeb.AuthController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use SourceSpaceWeb.Web, :controller

  plug Ueberauth

  def login(conn, _params, current_user, _claims) do
    render conn, "login.html", current_user: current_user,
      current_auths: auths(current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn,
    _params, current_user, _claims) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("login.html", current_user: current_user,
         current_auths: auths(current_user))
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params,
     current_user, _claims) do
    case Auth.get_or_register(auth, current_user, Repo) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in as #{user.name}")
        |> Guardian.Plug.sign_in(user, :access,
           perms: %{default: Guardian.Permissions.max})
        |> redirect(to: user_path(conn, :edit, user.id))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not authenticate. Error: #{reason}")
        |> render("login.html", current_user: current_user,
           current_auths: auths(current_user))
    end
  end

  def logout(conn, _params, current_user, _claims) do
    if current_user do
      conn
      |> Guardian.Plug.sign_out
      |> put_flash(:info, "Signed out")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:info, "Not logged in")
      |> redirect(to: "/")
    end
  end

  defp auths(nil), do: []
  defp auths(%Auth.User{} = user) do
    authorizations = Ecto.assoc(user, :authorizations)
    authorizations
    |> Repo.all
    |> Enum.map(&(&1.provider))
  end
end
