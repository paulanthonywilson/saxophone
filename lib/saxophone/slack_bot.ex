defmodule Saxophone.SlackBot do
  use Slacker
  use Slacker.Matcher

  alias Saxophone.Locomotion

  match ~r/play sax/i, :play_sax
  match ~r/play guitar/i, :play_guitar
  match ~r/^sax (forward|back|left|right|reverse)/i, :move
  match ~r/^sax stop/i, :stop
  match ~r/^sax step\s+(\d+)/i, :step_rate

  def play_sax(_pid, message) do
    say self, message["channel"], "Oh yeah, the Jazz man cometh!"
    Saxophone.Saxophonist.play(:saxophonist)
  end

  def play_guitar(_pid, message) do
    say self, message["channel"], "Air guitar ok?"
    Saxophone.Saxophonist.play(:guitarist)
  end


  def move(_pid, message, direction) do
    say self, message["channel"], "Moving #{direction}"
    case direction do
      "forward" -> Locomotion.forward
      "back" -> Locomotion.reverse
      "reverse" -> Locomotion.reverse
      "left" -> Locomotion.turn_left
      "right" -> Locomotion.turn_right
    end
  end

  def stop(_pid, message) do
    say self, message["channel"], "Stopping"
    Locomotion.stop
  end

  def step_rate(_pid, message, rate) do
    rate_number = rate |> String.to_integer
    say self, message["channel"], "Stepping at rate #{rate_number}"
    Locomotion.set_step_rate rate_number
  end


  # def handle_cast({:handle_incoming, event, message}, state) do
  #   IO.inspect {:incoming, event, message}
  #   {:noreply, state}
  # end
end
