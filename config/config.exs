# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rumbl,
  ecto_repos: [Rumbl.Repo],
  migration_primary_key: [type: :uuid]

# Configures the endpoint
config :rumbl, RumblWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AqgleuY0GZmaPCAD6cBq+AB1K0/LSw1wvtfGmNM8YnFu0mwnzdfSA2amp8JvcedO",
  render_errors: [view: RumblWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Rumbl.PubSub,
  live_view: [signing_salt: "+TzQVmOP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
