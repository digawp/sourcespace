defmodule Auth.Authorization do
  @moduledoc """
   The Authorization entity represents user authorisation means
   from different providers. It keeps track of the token and expiry, as
   well as hashed password for identity provider.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "authorizations" do
    field :provider, :string
    field :uid, :string
    field :token, :string
    field :refresh_token, :string
    field :expires_at, :integer
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    belongs_to :user, Auth.User

    timestamps()
  end

  @required_fields ~w(provider uid user_id token)a
  @optional_fields ~w(refresh_token expires_at)a

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:provider_uid)
  end
end
