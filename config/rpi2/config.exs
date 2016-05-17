use Mix.Config


config :saxophone, :cowboy_options, [port: 4000]

config :saxophone, :saxophonist, pin: 22, toggle_time: 500
config :saxophone, :guitarist, pin: 27, toggle_time: 500

config :saxophone, :ethernet_retry_interval_seconds, 1
config :saxophone, :slackbot_retry_seconds, 30
config :saxophone, :slackbot_start_delay_seconds, 3

config :saxophone, :steppers, [right: [21, 20, 16, 12],
                               left: [26, 19, 13, 6]]

config :porcelain, driver: Porcelain.Driver.Basic



import_config "config.secret.exs"
import_config "#{Mix.env}.exs"
