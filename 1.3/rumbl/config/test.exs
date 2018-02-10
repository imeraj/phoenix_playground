use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rumbl, RumblWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :rumbl, Rumbl.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "root",
  database: "rumbl_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, :log_rounds, 4

# Configures Phoenix Integration
config :phoenix_integration, endpoint: RumblWeb.Endpoint

config :rumbl, sql_sandbox: true