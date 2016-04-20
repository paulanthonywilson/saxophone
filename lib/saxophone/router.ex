defmodule Saxophone.Router do
  use Plug.Router
  plug Plug.Parsers, parsers: [:urlencoded]
  alias Saxophone.{StepperMotor, Locomotion, Saxophonist}

  @compiled_at :calendar.universal_time

  plug :match
  plug :dispatch

  def start_link do
    cowboy_options = Application.get_env(:saxophone, :cowboy_options)
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [], cowboy_options
  end

  get "/" do
    send_resp(conn, 200, "Hello" |> web_page)
  end

  post "/light_on" do
    :ok = Gpio.write(:led, 1)
    send_resp(conn, 200, "The light is on!" |> web_page)
  end

  post "/light_off" do
    :ok = Gpio.write(:led, 0)
    send_resp(conn, 200, "The light is off!" |> web_page)
  end

  post "play_sax" do
    :ok = Saxophonist.play(:saxophonist)
    send_resp(conn, 200, "Baker Street, it is not." |> web_page)
  end


  post "forward" do
    Locomotion.forward
    send_resp(conn, 200, "Forward!" |> web_page)
  end


  post "back" do
    Locomotion.reverse
    send_resp(conn, 200, "Back!" |> web_page)
  end


  post "stop" do
    Locomotion.stop
    send_resp(conn, 200, "Stopped!" |> web_page)
  end


  post "step_rate" do
    step_rate = conn.params["step_rate"] |> String.to_integer
    Locomotion.set_step_rate(step_rate)

    send_resp(conn, 200, "Stepping at #{step_rate}" |> web_page)
  end

  post "turn_left" do
    Locomotion.turn_left
    send_resp(conn, 200, "Left!" |> web_page)
  end

  post "turn_right" do
    Locomotion.turn_right
    send_resp(conn, 200, "Right!" |> web_page)
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp web_page(message) do
    step_rate = (:right_stepper |> StepperMotor.state).step_millis
    """
    <html>
      <head>
        <title>Led thingy</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
      </head>
      <body>
        <a href="/">Home</a>
        <p>Compiled at #{@compiled_at |> inspect}</p>
        <p>#{message}</p>
        <form action = "/play_sax" method="post">
          <input type="submit" value="Play Sax!"></input>
        </form>
        <form action = "/light_on" method="post">
          <input type="submit" value="Turn light on"></input>
        </form>
        <form action = "/light_off" method="post">
          <input type="submit" value="Turn light off"></input>
        </form>
        <hr/>
        <form action = "/forward" method="post">
          <input type="submit" value="forward"></input>
        </form>
        <form action = "/back" method="post">
          <input type="submit" value="back"></input>
        </form>
        <form action = "/stop" method="post">
          <input type="submit" value="stop"></input>
        </form>
        <form action = "/turn_left" method="post">
          <input type="submit" value="Left"></input>
        </form>
        <form action = "/turn_right" method="post">
          <input type="submit" value="Right"></input>
        </form>
        <form action = "/step_rate" method="post">
          <input type="number" name="step_rate" value="#{step_rate}"></input>
          <input type="submit" value="Step rate"></input>
        </form>
      </body>
    </html>
    """
  end
end
