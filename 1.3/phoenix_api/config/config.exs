# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_api,
  ecto_repos: [PhoenixApi.Repo]

# Configures the endpoint
config :phoenix_api, PhoenixApi.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FBwyfg7WftLm102gkgi/seCWgg+YgBHWWXa+AViJdE8eEJXCiLtH4IPgxTG5457K",
  render_errors: [view: PhoenixApi.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhoenixApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
