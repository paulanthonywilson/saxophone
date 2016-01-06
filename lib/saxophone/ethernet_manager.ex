defmodule Saxophone.EthernetManager do
  use GenServer

  def start_link(retry_interval, interface, ethernet_opts \\ [], otp_opts \\ []) do
    GenServer.start_link(__MODULE__, {retry_interval, interface, ethernet_opts}, otp_opts)
  end



  def init({retry_interval, interface, ethernet_opts}) do
    send(self, :start)
    Process.flag(:trap_exit, true)
    IO.inspect(self)
    {:ok, %{retry_interval: retry_interval, interface: interface, ethernet_opts: ethernet_opts}}
  end


  def handle_info(:start, %{interface: interface, ethernet_opts: ethernet_opts} = status) do
    {:ok, eth_pid} = Nerves.IO.Ethernet.setup(interface, ethernet_opts)
    Process.monitor(eth_pid)
    {:noreply, status}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, %{retry_interval: retry_interval} = status) do
    Process.send_after(self, :start, retry_interval)
    {:noreply, status}
  end

  def handle_info({:EXIT, _pid, reason}, status) do
    {:noreply, status}
  end

  def handle_info(wat, status) do
    IO.inspect({wat,status})
    {:noreply, status}
  end
end
