defmodule Saxophone.NetworkingSupervisor do
  use Supervisor

  @ethernet_opts Application.get_env(:saxophone, :ethernet_opts) || []

  @slackbot_retry_time Application.get_env(:saxophone, :slackbot_retry_seconds) |> :timer.seconds
  @slackbot_start_delay Application.get_env(:saxophone, :slackbot_start_delay_seconds) |> :timer.seconds

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Nerves.Networking, [:eth0, @ethernet_opts], function: :setup),
      worker(Saxophone.GenServerRestarter, [Saxophone.SlackWithNtpSupervisor,
                                  :start_link,
                                  [],
                                  @slackbot_retry_time,
                                  [name: :slackbot_and_ntp_manager],
                                  @slackbot_start_delay])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
