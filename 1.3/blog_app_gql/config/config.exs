# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blog_app_gql, ecto_repos: [BlogAppGql.Repo]

# Configures the endpoint
config :blog_app_gql, BlogAppGql.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+yyPTDfUl+8TYkEi6J7ZfNeqsUqlOMQnv6mGW/XIR8a9YnRM46GtkR1Y0Q4JmjkK",
  render_errors: [view: BlogAppGql.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: BlogAppGql.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# configures Guardian
config :blog_app_gql, BlogAppGql.Guardian,
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  issuer: "BlogAppGql",
  ttl: {30, :days},
  allowed_drift: 2000,
  # optional
  verify_issuer: true,
  # generated using: JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
  secret_key: %{"k" => "3gx0vXjUD2BJ8xfo_aQWIA", "kty" => "oct"},
  serializer: BlogAppGql.Guardian


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
