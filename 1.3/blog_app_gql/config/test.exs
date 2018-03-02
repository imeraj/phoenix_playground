use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blog_app_gql, BlogAppGql.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :blog_app_gql, BlogAppGql.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "phoenix",
  hostname: "localhost",
  port: 3306,
  database: "blog_app_gql_test",
  pool: Ecto.Adapters.SQL.Sandbox
