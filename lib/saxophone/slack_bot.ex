defmodule Saxophone.SlackBot do
  use Slacker
  use Slacker.Matcher

  match ~r/play sax/i, :play_sax

  def play_sax(_pid, message) do
    IO.inspect {:play, message}
    Saxophone.Saxophonist.play(:saxophonist)
  end
end
