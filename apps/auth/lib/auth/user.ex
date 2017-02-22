defmodule Auth.User do
  @moduledoc """
    The User entity contains basic user data such as name and e-mail.
    A user can have many authorisations from different providers.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Auth.Repo

  @type t :: %__MODULE__{}

  schema "users" do
    field :name, :string
    field :email, :string
    field :is_admin, :boolean

    has_many :authorizations, Auth.Authorization

    timestamps()
  end

  @required_fields ~w(name email)a
  @optional_fields ~w()a

  def build(params) do
    changeset(%Auth.User{}, params)
  end

  def registration_changeset(user, params \\ :empty) do
    user
    |> cast(params, ~w(email name)a)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/.*@.*/)
  end

  def changeset(user, params \\ :empty) do
    user
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/.*@.*/)
  end

  def make_admin!(user) do
    user
    |> cast(%{is_admin: true}, ~w(is_admin)a)
    |> Repo.update!
  end
end
