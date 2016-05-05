defmodule Saxophone.Supervisor do
  use Supervisor

  @led_pin Application.get_env(:saxophone, :led_pin)
  @sax_pin Application.get_env(:saxophone, :saxophonist)[:pin]
  @sax_toggle_time Application.get_env(:saxophone, :saxophonist)[:toggle_time]


  @guitar_pin Application.get_env(:saxophone, :guitarist)[:pin]
  @guitar_toggle_time Application.get_env(:saxophone, :guitarist)[:toggle_time]


  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Saxophone.Router, []),
      worker(Gpio, [@led_pin, :output, [name: :led]]),
      worker(Saxophone.Saxophonist, [@sax_pin, @sax_toggle_time, [name: :saxophonist]], id: :saxophonist),
      worker(Saxophone.Saxophonist, [@guitar_pin, @guitar_toggle_time, [name: :guitarist]], id: :guitarist),
      supervisor(Saxophone.LocomotionSupervisor, []),
      supervisor(Saxophone.AlwaysRestartSupervisor, []),
      worker(Saxophone.Ntp, []),
      ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Saxophone do
  use Application

  @resolve_conf_config Application.get_env(:saxophone, :resolv_conf_content)

  def start(_type, _args) do
    Saxophone.Supervisor.start_link
  end
end
