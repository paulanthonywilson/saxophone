defmodule Saxophone .Saxophonist do
  use GenServer
  @moduledoc """
  Makes a M&M's rockstar candy saxophonist play a tune.

  The play button is modified with a soldering iron, so that if properly wired up,
  the little fellow can be made to play by toggling a Gpio pin to high for a
  few moments
  """

  def start_link(pin, toggle_time, opts \\ []) do
    GenServer.start_link(__MODULE__, {pin, toggle_time}, opts)
  end


  def init({pin, toggle_time}) do
    {:ok, gpio_pid} = Gpio.start_link(pin, :output)
    {:ok, %{gpio_pid: gpio_pid, toggle_time: toggle_time}}
  end

  def play(pid) do
    GenServer.cast(pid, :play)
  end


  def handle_cast(:play, %{gpio_pid: gpio_pid, toggle_time: toggle_time} = state) do
    gpio_pid |> Gpio.write(1)
    :timer.send_after(toggle_time, :turn_off)
    {:noreply, state}
  end

  def handle_info(:turn_off, %{gpio_pid: gpio_pid} = status) do
    gpio_pid |> Gpio.write(0)
    {:noreply, status}
  end

end
