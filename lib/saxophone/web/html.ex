defmodule Saxophone.Web.Html do
  @compiled_at :calendar.universal_time
  @css File.read! "lib/saxophone/web/saxophone.css"

  alias Saxophone.{StepperMotor}

  def css do
    @css
  end

  def control_page(message) do
    step_rate = (:right_stepper |> StepperMotor.state).step_millis
    now = :erlang.universaltime
    """
    <html>
      <head>
        <title>Sax Control</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/saxophone.css") %>">
      </head>
  <body>
    <div class="controller">
      <div class="controller__right-controls">
        <table class="controller__music">
          <tr>
            <td colspan="3">
              <h2 class="controller__title"><i class="fa fa-music"></i> Music</h2>
            </td>
          </tr>
          <tr>
            <td>
              <form action = "/play_sax" method="post">
                <input type="submit" value="Play Sax!"></input>
              </form>
            </td>
            <td>
              <form action = "/play_guitar" method="post">
                <input type="submit" value="Play Guitar!"></input>
              </form>
            </td>
            <td>
              <form action = "/play_all" method="post">
                <input type="submit" value="Full cacophony!"></input>
              </form>
            </td>
          </tr>
        </table>

        <table class="controller__lights">
          <tr>
            <td colspan="2">
              <h2 class="controller__title"><i class="fa fa-lightbulb-o"></i> Lights</h2>
            </td>
          </tr>
          <tr>
            <td>
              <form action = "/light_on" method="post">
                <input type="submit" value="on"></input>
              </form>
            </td>
            <td>
              <form action = "/light_off" method="post">
                <input type="submit" value="off"></input>
              </form>
            </td>
          </tr>
        </table>

      </div>
      <div class="controller__left-controls">
        <table>
          <tr>
            <td colspan="3">
              <h2 class="controller__title">
                <i class="fa fa-arrows"></i> Movement</h2>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>
              <form action = "/forward" method="post">
                <button type="submit">
                &utrif;
                </button>
              </form>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              <form action = "/turn_left" method="post">
                <button type="submit">
                &ltrif;
                </button>
              </form>
            </td>
            <td>
              <form action = "/stop" method="post">
                <button type="submit">
                &otimes;
                </button>
              </form>
            </td>
            <td>
              <form action = "/turn_right" method="post">
                <button type="submit">
                &rtrif;
                </button>
              </form>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>
              <form action = "/back" method="post">
                <button type="submit">
                &dtrif;
                </button>
              </form>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="3">
              <form action = "/step_rate" method="post" class="controller__steps">
                <input type="number" name="step_rate" value="#{step_rate}"></input>
                <input type="submit" value="Step rate"></input>
              </form>
            </td>
          </tr>
        </table>
      </div>
    </div>
    <div class="home-link">
      <a href="/">Home</a>
    </div>
    <p class="message">#{message}</p>
    <p>Page loaded at #{now |> format_date_time}</p>
    <p>Compiled at #{@compiled_at |> format_date_time}</p>
      </body>
    </html>
    """
  end


  defp format_date_time({{year, month, day}, {hour, minute, second}}) do
    "#{hour}:#{minute}:#{second} UTC on #{day} #{short_word_month(month)} #{year}"
  end

  defp short_word_month(1), do: "Jan"
  defp short_word_month(2), do: "Feb"
  defp short_word_month(3), do: "Mar"
  defp short_word_month(4), do: "Apr"
  defp short_word_month(5), do: "May"
  defp short_word_month(6), do: "Jun"
  defp short_word_month(7), do: "Jul"
  defp short_word_month(8), do: "Aug"
  defp short_word_month(9), do: "Sep"
  defp short_word_month(10), do: "Oct"
  defp short_word_month(11), do: "Nov"
  defp short_word_month(12), do: "Dec"
end
