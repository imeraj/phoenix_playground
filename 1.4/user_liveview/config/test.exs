use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_liveview, UserLiveviewWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :user_liveview, UserLiveview.Repo,
  username: "phoenix",
  password: "phoenix",
  database: "user_liveview_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
