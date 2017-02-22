defmodule Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auth.Repo

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
    |> cast(params, ~w(email password)a)
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
