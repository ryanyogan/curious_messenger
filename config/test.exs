use Mix.Config

config :curious_messenger, CuriousMessengerWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

import_config "test.secret.exs"
