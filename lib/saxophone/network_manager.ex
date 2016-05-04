defmodule Saxophone.NetworkManager do
  use GenServer

  @ethernet_retry_seconds Application.get_env(:saxophone, :ethernet_retry_interval_seconds)

  def start_link do
    GenServer.start_link(__MODULE__, :timer.seconds(@ethernet_retry_seconds), name: __MODULE__)
  end

  def init(retry_interval) do
    send(self, :start)
    Process.flag(:trap_exit, true)
    {:ok, %{retry_interval: retry_interval}}
  end


  def handle_info(:start, status) do
    {:ok, sup_pid} = Saxophone.NetworkSupervisor.start_link
    Process.monitor(sup_pid)
    {:noreply, status}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, %{retry_interval: retry_interval} = status) do
    Process.send_after(self, :start, retry_interval)
    {:noreply, status}
  end

  def handle_info({:EXIT, _pid, _reason}, status) do
    {:noreply, status}
  end

  def handle_info(wat, status) do
    IO.inspect({wat,status})
    {:noreply, status}
  end
end
