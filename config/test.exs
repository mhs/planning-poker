use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :planning_poker, PlanningPokerWeb.Endpoint,
  http: [port: 4001],
  server: true

config :planning_poker, sql_sandbox: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :planning_poker, PlanningPoker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "planning_poker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
