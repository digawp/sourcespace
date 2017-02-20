use Mix.Config

config :sourcespace_web, SourceSpaceWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "travis_ci_test",
  hostname: "localhost",
  pool_size: 10
