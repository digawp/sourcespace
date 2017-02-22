# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :auth, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:auth, :key)
#
config :logger, level: :debug

config :auth, ecto_repos: [Auth.Repo]

config :ueberauth, Ueberauth,
  providers: [
    identity: { Ueberauth.Strategy.Identity, [callback_methods: ["POST"]] }
  ]

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
    ]
  }

config :guardian_db, GuardianDb,
  repo: Auth.Repo,
  sweep_interval: 60 # 60 minutes

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "#{Mix.env}.exs"
