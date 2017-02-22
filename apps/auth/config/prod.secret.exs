use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sourcespace_dev",
  pool_size: 20
