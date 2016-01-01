use Mix.Config


config :saxophone, :cowboy_options, [port: 4000]
config :saxophone, :led_pin, 17

import_config "#{Mix.env}.exs"
