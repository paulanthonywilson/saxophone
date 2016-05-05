defmodule Saxophone.GenServerRestarter do
  use GenServer

  def start_link(retry_interval, restarter_opts, module, function, args) do
    GenServer.start_link(__MODULE__,
                         %{retry_interval: retry_interval,
                           module: module,
                           function: function,
                           args: args},
                         restarter_opts)
  end

  def init(status) do
    send(self, :start)
    Process.flag(:trap_exit, true)
    {:ok, status}
  end

  def handle_info(:start, state = %{module: module, function: function, args: args}) do
    {:ok, pid} = apply(module, function, args)
    Process.link(pid)
    {:noreply, state}
  end

  def handle_info({:EXIT, _pid, _reason}, status = %{retry_interval: retry_interval}) do
    Process.send_after(self, :start, retry_interval)
    {:noreply, status}
  end

  def handle_info(wat, status) do
    IO.inspect wat
    {:noreply, status}
  end

end
