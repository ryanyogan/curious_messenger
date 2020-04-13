use Mix.Config

# Configure your database
config :curious_messenger, CuriousMessenger.Repo,
  username: "postgres",
  password: "postgres",
  database: "curious_messenger_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :curious_messenger, CuriousMessengerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
