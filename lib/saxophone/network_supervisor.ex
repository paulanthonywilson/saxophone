defmodule  Saxophone.NetworkSupervisor do
  use Supervisor

  @ethernet_opts Application.get_env(:saxophone, :ethernet_opts) || []
  @slackbot_token  Application.get_env(:saxophone, :slackbot_token)

  IO.inspect @ethernet_opts

  def start_link do
    Supervisor.start_link(__MODULE__, {:eth0, @ethernet_opts}, name: __MODULE__)
  end

  def init({interface, ethernet_opts}) do
    children = [
      worker(Nerves.Networking, [interface, @ethernet_opts], function: :setup),
      worker(Saxophone.SlackBot, [@slackbot_token]),
    ]
    supervise(children, strategy: :one_for_one)
  end
end
