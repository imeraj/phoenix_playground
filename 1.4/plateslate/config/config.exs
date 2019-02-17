# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :plateslate,
  ecto_repos: [Plateslate.Repo]

# Configures the endpoint
config :plateslate, PlateslateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kiffU+wxGJCZB1G0n3xAZpR5B9CaoSyMD3GLG3aRyWc1uYIhgp1b3F9FBAXZDl6n",
  render_errors: [view: PlateslateWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Plateslate.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
