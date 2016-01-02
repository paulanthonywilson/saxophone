defmodule SaxophonistTest do
  use ExUnit.Case
  alias Saxophone.Saxophonist

  @gpio :"gpio_#{Application.get_env(:saxophone, :saxophonist)[:pin]}"

  @moduledoc """
  Saxophonist is set up as an GenSever in the application, named :saxophonist.
  The test toggle time value is 0
  """

  setup do
    @gpio |> Gpio.reset_pin_states
    :ok
  end

  test "toggle time should be configured to zero in the test environment" do
    assert 0 == Application.get_env(:saxophone, :saxophonist)[:toggle_time]
  end

  test "play toggles the pin on and off" do
    Saxophonist.play(:saxophonist)
    :timer.sleep(1)
    assert [1, 0] == @gpio |> Gpio.pin_state_log
  end
end
