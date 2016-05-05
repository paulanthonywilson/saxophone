defmodule Saxophone.SlackBot do
  use Slacker.Matcher
  use Slacker

  match ~r/play sax/i, :play_sax

  def play_sax(_pid, message) do
    IO.inspect {:play, message}
    say self, message["channel"], "Oh, bugger off"
    Saxophone.Saxophonist.play(:saxophonist)
  end

  # def handle_cast({:handle_incoming, event, message}, state) do
  #   IO.inspect {:incoming, event, message}
  #   {:noreply, state}
  # end
end
