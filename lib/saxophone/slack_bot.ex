defmodule Saxophone.SlackBot do
  use Slacker
  use Slacker.Matcher

  match ~r/play sax/i, :play_sax

  def play_sax(_pid, _message) do
    Saxophone.Saxophonist.play(:saxophonist)
  end
end
