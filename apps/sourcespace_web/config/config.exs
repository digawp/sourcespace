# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sourcespace_web,
  namespace: SourceSpaceWeb,
  ecto_repos: [SourceSpaceWeb.Repo]

# Configures the endpoint
config :sourcespace_web, SourceSpaceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LYS3pNrxyr/qgE0pfazhCV7Blo769I0/vPR3nrngjqYrDIRBDpnP8S8XU7qlx9Zw",
  render_errors: [view: SourceSpaceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SourceSpaceWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
