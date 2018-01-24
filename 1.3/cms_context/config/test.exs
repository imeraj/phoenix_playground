use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cms_context, CmsContextWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cms_context, CmsContext.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "root",
  hostname: "localhost",
  port: 3306,
  database: "cms_context_test",
  pool_size: 10
