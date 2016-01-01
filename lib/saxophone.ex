defmodule Saxophone.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Saxophone.Router, []),
      worker(Ethernet, []),
      worker(Gpio, [17, :output, [name: :gpio_17]])
      ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Saxophone do
  use Application

  def start(_type, _args) do
    Saxophone.Supervisor.start_link
  end
end
