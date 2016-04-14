defmodule Saxophone.StepperMotor do
  use GenServer

  @position_pin_values [
    [0, 0, 0, 1],
    [0, 0, 1, 1],
    [0, 0, 1, 0],
    [0, 1, 1, 0],
    [0, 1, 0, 0],
    [1, 1, 0, 0],
    [1, 0, 0, 0],
    [1, 0, 0, 1],
  ]

  @moduledoc """
  Represents the interface, via GPIO pins, to a stepper motor driver. Can adjust speed and direction.
  """

  def start_link(pin_ids = [_, _, _, _], opts \\ []) do
    GenServer.start_link(__MODULE__, pin_ids, opts)
  end


  ## API

  @doc """
  Set direction, either :forward, :back, or :neutral
  """
  def set_direction(pid, direction) do
    pid |> GenServer.call({:set_direction, direction})
  end

  @doc """
  Set the step rate in millisections
  """
  def set_step_rate(pid, step_rate) do
    pid |> GenServer.call({:set_step_rate, step_rate})
  end

  ## Callbacks
  def init(pin_ids) do
    gpio_pins = pin_ids |> Enum.map(fn pin ->
      {:ok, gpio_pid} = Gpio.start_link(pin, :output)
      gpio_pid
    end)

    send(self, :step)
    {:ok, %{pins: gpio_pins, direction: :neutral, step_millis: 100, position: 0}}
  end

  def handle_call({:set_direction, direction}, _from, status) do
    send(self, :step)
    {:reply, :ok, %{status | direction: direction}}
  end

  def handle_call({:set_step_rate, step_rate}, _from, status) do
    send(self, :step)
    {:reply, :ok, %{status | step_millis: step_rate}}
  end

  def handle_info(:step, status = %{pins: pins, direction: direction, step_millis: step_millis, position: position}) do
    @position_pin_values
    |> Enum.at(position)
    |> Enum.zip(pins)
    |> Enum.each(fn {value, pin} ->
      pin |> Gpio.write(value)
    end)

    step_again(direction, step_millis)

    {:noreply, %{status | position: new_position(position, direction)}}
  end

  defp step_again(:neutral, _) do
  end

  defp step_again(_, step_millis) do
    Process.send_after(self, :step, step_millis)
  end

  defp new_position(position, :neutral) do
    position
  end

  defp new_position(position, :forward) do
    (position + 1) |> rem(8)
  end

  defp new_position(position, :back) do
    (8 + position - 1) |> rem(8)
  end
end
