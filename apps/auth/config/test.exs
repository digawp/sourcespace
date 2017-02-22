use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sourcespace_web_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

if System.get_env("TRAVIS") != nil do
  import_config "travis_ci_test.exs"
end
