defmodule Saxophone.Supervisor do
  use Supervisor

  @led_pin Application.get_env(:saxophone, :led_pin)

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Saxophone.Router, []),
      worker(Ethernet, []),
      worker(Gpio, [@led_pin, :output, [name: :led]])
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
