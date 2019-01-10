use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :minitwitter, MinitwitterWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :minitwitter, Minitwitter.Repo,
  username: "phoenix",
  password: "phoenix",
  database: "minitwitter_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
