use Mix.Config

config :curious_messenger,
  ecto_repos: [CuriousMessenger.Repo]

config :curious_messenger, CuriousMessengerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aZ8lWLDFH7ffNyClPGr0YUmCakFTQI2hVsp3Re11kTG/eEhuSQe4gAeyj4lfBesJ",
  render_errors: [view: CuriousMessengerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CuriousMessenger.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "EEx9vG5l4MFr7wPyHJ8CmZ32JJyJcg23"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
