# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hello_phoenix,
  ecto_repos: [HelloPhoenix.Repo]

# Configures the endpoint
config :hello_phoenix, HelloPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "91qmZoLgfd1igy1YtQ5elwNXIpRhiTjrSwxnSFdv0zrx4P5jhhZv83vQ6pF/p7I9",
  render_errors: [view: HelloPhoenix.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HelloPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
