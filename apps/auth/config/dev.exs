use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sourcespace_dev",
  hostname: "localhost"

config :guardian, Guardian,
  issuer: "Auth.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Auth.GuardianSerializer,
  secret_key: to_string(Mix.env),
  hooks: GuardianDb,
  permissions: %{
    default: [
      :read_profile,
      :write_profile,
      :read_token,
      :revoke_token,
    ],
  }
