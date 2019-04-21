# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :github_liveview, GithubLiveviewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yv8R+fqagrGAFzGvSez7XQ4jk7ZvIvqzDbptqBQgqC0ivFl29c/F5vjFqJ4UkB0Q",
  render_errors: [view: GithubLiveviewWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GithubLiveview.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "Ld1UHalyXGgIIKV6s62ePqeoGCApat4e"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
