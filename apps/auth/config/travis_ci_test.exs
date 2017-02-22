use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "travis_ci_test",
  hostname: "localhost",
  pool_size: Ecto.Adapters.SQL.Sandbox
