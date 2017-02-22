use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sourcespace_web_dev",
  pool_size: 10
