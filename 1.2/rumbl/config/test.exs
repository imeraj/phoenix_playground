use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rumbl, Rumbl.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Ease up number of hashing rounds to speed up tests
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure your database
config :rumbl, Rumbl.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "phoenix",
  database: "rumbl_dev_test",
  hostname: "localhost",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox
