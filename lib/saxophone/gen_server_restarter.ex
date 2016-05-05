defmodule Saxophone.GenServerRestarter do
  use GenServer

  def start_link(retry_interval, restarter_opts \\ [], module, args, opts \\ []) do
    GenServer.start_link(__MODULE__,
                         %{retry_interval: retry_interval,
                           module: module,
                           args: args,
                           opts: opts},
                         restarter_opts)
  end

  def init(status) do
    send(self, :start)
    Process.flag(:trap_exit, true)
    {:ok, status}
  end

  def handle_info(:start, state = %{module: module, args: args, opts: opts}) do
    GenServer.start_link(module, args, opts)
    {:noreply, state}
  end

  def handle_info({:EXIT, _pid, _reason}, status = %{retry_interval: retry_interval}) do
    Process.send_after(self, :start, retry_interval)
    {:noreply, status}
  end

end
