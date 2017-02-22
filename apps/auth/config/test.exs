use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sourcespace_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
