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

config :mime, :types, %{
	"application/vnd.app.v1+json" => [:v1],
	"application/vnd.app.v2+json" => [:v2]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# config Guardian
config :guardian, Guardian,
  hooks: GuardianDb,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "PhoenixApi",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  # generated using: JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
  secret_key: %{"k" => "3gx0vXjUD2BJ8xfo_aQWIA", "kty" => "oct"},
  serializer: PhoenixApi.GuardianSerializer

# config GuardianDB
config :guardian_db, GuardianDb,
        repo: PhoenixApi.Repo,
        sweep_interval: 120

config :phoenix_api, PhoenixApi.Mailer,
    adapter: Bamboo.SMTPAdapter,
    server: "smtp.gmail.com",
    port: 587,
    username: "demo.rails007",
    password: "mcmxcd123",
    tls: :if_available, # can be `:always` or `:never`
    ssl: false, # can be `true`
    retries: 3