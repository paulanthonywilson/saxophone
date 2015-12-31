use Mix.Config


config :saxophone, :cowboy_options, [port: 8080]

import_config "#{Mix.env}.exs"
