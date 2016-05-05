defmodule Saxophone.AlwaysRestartSupervisor do
  use Supervisor

  @ethernet_retry_seconds Application.get_env(:saxophone, :ethernet_retry_interval_seconds)
  @ethernet_opts Application.get_env(:saxophone, :ethernet_opts) || []
  @slackbot_token  Application.get_env(:saxophone, :slackbot_token)
  @slackbot_retry_seconds  Application.get_env(:saxophone, :slackbot_retry_seconds)

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      worker(Saxophone.GenServerRestarter,
             [:timer.seconds(@ethernet_retry_seconds),
              [name: :ethernet_manager],
              Nerves.Networking,
              [:eth0, @ethernet_opts],
              [function: :setup]], id: :ethernet_manager),
      worker(Saxophone.GenServerRestarter,
             [:timer.seconds(@slackbot_retry_seconds),
              [name: :slackbot_manager],
              Saxophone.SlackBot,
              [@slackbot_token],
             [name: :slackbot]], id: :slackbot_manager)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
