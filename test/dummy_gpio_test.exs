defmodule DummyGpioTest do
  use ExUnit.Case

  setup do
    {:ok, gpio_pid} = Gpio.start_link(1, :output)
    {:ok, gpio_pid: gpio_pid}
  end

  test "initial pin state is zero", %{gpio_pid: gpio_pid} do
    assert 0 == gpio_pid |> Gpio.read
  end

  test "pin state can be written", %{gpio_pid: gpio_pid} do
    gpio_pid |> Gpio.write(1)
    assert 1 == gpio_pid |> Gpio.read
  end

  test "a log of written states is kept", %{gpio_pid: gpio_pid} do
    gpio_pid |> Gpio.write(1)
    gpio_pid |> Gpio.write(0)
    gpio_pid |> Gpio.write(1)
    gpio_pid |> Gpio.write(1)

    assert [1, 0, 1, 1] == gpio_pid |> Gpio.pin_state_log
  end

  test "reset_pin_states resets the log and the pin state to zero", %{gpio_pid: gpio_pid} do
    gpio_pid |> Gpio.write(1)
    gpio_pid |> Gpio.write(0)
    gpio_pid |> Gpio.reset_pin_states

    assert [] == gpio_pid |> Gpio.pin_state_log
    assert 0 == gpio_pid |> Gpio.read
  end
end
