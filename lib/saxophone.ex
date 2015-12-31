defmodule Saxophone.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Saxophone.Router, [])
    ] ++
      case Application.get_env(:saxophone, :start_ethernet) do
        true -> [worker(Ethernet, [])]
        _ -> []
      end
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Saxophone do
  use Application

  def start(_type, _args) do
    Saxophone.Supervisor.start_link
  end
end
