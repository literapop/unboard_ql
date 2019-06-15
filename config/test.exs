use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :unboard_ql, UnboardQlWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :unboard_ql, UnboardQl.Repo,
  username: "postgres",
  password: "postgres",
  database: "unboard_ql_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
