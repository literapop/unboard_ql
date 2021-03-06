# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :unboard_ql, UnboardQl.Repo,
  database: "unboard_dev",
  username: "unboard_dev",
  password: "unboard_dev",
  hostname: "localhost"

config :cors_plug,
  origin: ["https://www.unboard.today", "http://www.unboard.today", "http://localhost:3000", "http://localhost:4000"],
  max_age: 86400,
  methods: ["GET", "POST"]

config :unboard_ql,
  ecto_repos: [UnboardQl.Repo]

# Configures the endpoint
config :unboard_ql, UnboardQlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1GPA0oxtN2REcp+uM7vAfxLLe5rWRNdUzQ5WwOnMYwvWxgwrIAW1ibm3/baKSDNv",
  render_errors: [view: UnboardQlWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UnboardQl.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
