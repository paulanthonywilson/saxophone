use Mix.Config


config :saxophone, :cowboy_options, [port: 8080]
config :saxophone, :start_ethernet, false

import_config "#{Mix.env}.exs"
