use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sourcespace_web, SourceSpaceWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sourcespace_web, SourceSpaceWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sourcespace_web_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

if System.get_env("TRAVIS") != nil do
  import_config "travis_ci_test.exs"
end
