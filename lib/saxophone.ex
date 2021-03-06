defmodule Saxophone.Supervisor do
  @moduledoc false

  use Supervisor


  @led_pin Application.get_env(:saxophone, :led_pin)
  @sax_pin Application.get_env(:saxophone, :saxophonist)[:pin]
  @sax_toggle_time Application.get_env(:saxophone, :saxophonist)[:toggle_time]


  @guitar_pin Application.get_env(:saxophone, :guitarist)[:pin]
  @guitar_toggle_time Application.get_env(:saxophone, :guitarist)[:toggle_time]

  @ethernet_retry_seconds Application.get_env(:saxophone, :ethernet_retry_interval_seconds)

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Saxophone.Web.Router, []),
      worker(Saxophone.Saxophonist, [@sax_pin, @sax_toggle_time, [name: :saxophonist]], id: :saxophonist),
      worker(Saxophone.Saxophonist, [@guitar_pin, @guitar_toggle_time, [name: :guitarist]], id: :guitarist),
      supervisor(Saxophone.LocomotionSupervisor, []),
      worker(Saxophone.GenServerRestarter, [{Saxophone.NetworkingSupervisor, :start_link, []},
             ethernet_retry_time, [name: :networking_manager]]),
      ]
    supervise(children, strategy: :one_for_one)
  end

  defp ethernet_retry_time, do: @ethernet_retry_seconds |> :timer.seconds
end

defmodule Saxophone do
  @moduledoc false
  use Application

  @resolve_conf_config Application.get_env(:saxophone, :resolv_conf_content)

  def start(_type, _args) do
    Saxophone.Supervisor.start_link
  end
end
