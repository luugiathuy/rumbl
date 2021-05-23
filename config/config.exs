# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :rumbl,
  ecto_repos: [Rumbl.Repo]

config :rumbl, Rumbl.Repo, migration_primary_key: [type: :uuid]
config :rumbl, Rumbl.Repo, migration_timestamps: [type: :timestamptz]

config :rumbl_web,
  ecto_repos: [Rumbl.Repo],
  generators: [context_app: :rumbl]

# Configures the endpoint
config :rumbl_web, RumblWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aUP/xr212jY1G0XAM72UCL3oX/M5/kqIB0prLCS0KWfYQ1fwe3Rdeqvj546B/ADg",
  render_errors: [view: RumblWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: RumblWeb.PubSub,
  live_view: [signing_salt: "5T2Rdw7M"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
