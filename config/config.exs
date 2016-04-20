use Mix.Config


config :saxophone, :cowboy_options, [port: 4000]
config :saxophone, :led_pin, 17

config :saxophone, :saxophonist, pin: 4, toggle_time: 500

config :saxophone, :ethernet_retry_interval_seconds, 10

config :saxophone, :steppers, [right: [21, 20, 16, 12],
                               left: [26, 19, 13, 6]]

import_config "config.secret.exs"
import_config "#{Mix.env}.exs"
