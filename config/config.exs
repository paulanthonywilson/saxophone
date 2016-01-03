use Mix.Config


config :saxophone, :cowboy_options, [port: 4000]
config :saxophone, :led_pin, 17

config :saxophone, :saxophonist, pin: 4, toggle_time: 500

import_config "config.secret.exs"
import_config "#{Mix.env}.exs"
