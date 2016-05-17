defmodule Saxophone.NetworkingSupervisor do
  @moduledoc """
  Supervises the Ethernet connection, and a GenServerRestarter that
  will bring up the rest of the outbound networking.

  A start delay is to ensure that the Ethernet comes up before anything tries to use
  HTTPoison. If HTTPoison is used before the network is up, then no domains will ever
  be resolved.
  """

  use Supervisor

  @ethernet_opts Application.get_env(:saxophone, :ethernet_opts) || []

  @slackbot_retry_seconds Application.get_env(:saxophone, :slackbot_retry_seconds)
  @slackbot_start_delay_seconds Application.get_env(:saxophone, :slackbot_start_delay_seconds)

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Nerves.Networking, [:eth0, @ethernet_opts], function: :setup),
      worker(Saxophone.GenServerRestarter, [
            {Saxophone.SlackWithNtpSupervisor, :start_link, []},
            slackbot_retry_time,
            [name: :slackbot_and_ntp_manager],
            slackbot_start_delay])
    ]

    supervise(children, strategy: :rest_for_one)
  end

  defp slackbot_retry_time, do: @slackbot_retry_seconds |> :timer.seconds
  defp slackbot_start_delay, do: @slackbot_start_delay_seconds |> :timer.seconds
end
