defmodule Saxophone.SlackWithNtpSupervisor do
  @moduledoc """
  Supervise NTP and SlackBot. NTP should only fail on initialisation.

  Uses `rest_for_one`. If NTP fails it will take down the SlackBot as well,
  but not vice versa.
  """

  use Supervisor

  @slackbot_token  Application.get_env(:saxophone, :slackbot_token)

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Saxophone.Ntp, []),
      worker(Saxophone.SlackBot, [@slackbot_token, [name: :slackbot]]),
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
