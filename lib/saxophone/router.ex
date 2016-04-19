defmodule Saxophone.Router do
  use Plug.Router
  plug Plug.Parsers, parsers: [:urlencoded]
  alias Saxophone.{StepperMotor, Saxophonist}

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
    :right_stepper |> StepperMotor.set_direction(:forward)
    send_resp(conn, 200, "Forward!" |> web_page)
  end


  post "back" do
    :right_stepper |> StepperMotor.set_direction(:back)
    send_resp(conn, 200, "Back!" |> web_page)
  end


  post "stop" do
    :right_stepper |> StepperMotor.set_direction(:neutral)
    send_resp(conn, 200, "Stopped!" |> web_page)
  end


  post "slower" do
    :right_stepper |> StepperMotor.set_step_rate(50)
    send_resp(conn, 200, "Slower!" |> web_page)
  end


  post "slow" do
    :right_stepper |> StepperMotor.set_step_rate(15)
    send_resp(conn, 200, "Slow!" |> web_page)
  end

  post "step_rate" do
    step_rate = conn.params["step_rate"] |> String.to_integer
    :right_stepper |> StepperMotor.set_step_rate(step_rate)

    send_resp(conn, 200, "yada" |> web_page)
  end

  post "low_gear" do
    :right_stepper |> StepperMotor.set_low_gear
    send_resp(conn, 200, "Low!" |> web_page)
  end

  post "high_gear" do
    :right_stepper |> StepperMotor.set_high_gear
    send_resp(conn, 200, "High!" |> web_page)
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
        <form action = "/step_rate" method="post">
          <input type="number" name="step_rate" value="#{step_rate}"></input>
          <input type="submit" value="Step rate"></input>
        </form>
        <form action = "/low_gear" method="post">
        <input type="submit" value="low gear"></input>
        </form>
        <form action = "/high_gear" method="post">
        <input type="submit" value="high gear"></input>
        </form>
      </body>
    </html>
    """
  end
end
