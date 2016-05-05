defmodule Saxophone.AlwaysRestartSupervisor do
  use Supervisor
  alias Saxophone.GenServerRestarter

  @ethernet_retry_time Application.get_env(:saxophone, :ethernet_retry_interval_seconds) |> :timer.seconds
  @ethernet_opts Application.get_env(:saxophone, :ethernet_opts) || []

  @slackbot_token  Application.get_env(:saxophone, :slackbot_token)
  @slackbot_retry_time Application.get_env(:saxophone, :slackbot_retry_seconds) |> :timer.seconds

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      worker(GenServerRestarter,
             [@ethernet_retry_time,
              [name: :ethernet_manager],
              Nerves.Networking,
              :setup,
              [:eth0, @ethernet_opts]],
             id: :ethernet_manager),
      worker(GenServerRestarter,
             [@slackbot_retry_time,
              [name: :slackbot_manager],
              Saxophone.SlackBot,
              :start_link,
              [@slackbot_token]],
             id: :slackbot_manager)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
