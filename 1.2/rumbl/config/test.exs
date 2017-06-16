use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rumbl, Rumbl.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :rumbl, Rumbl.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "phoenix",
  database: "rumbl_dev",
  hostname: "localhost",
  pool_size: Ecto.Adapters.SQL.Sandbox
