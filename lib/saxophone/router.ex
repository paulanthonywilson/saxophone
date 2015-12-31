defmodule Saxophone.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_link do
    cowboy_options = Application.get_env(:saxophone, :cowboy_options)
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [], cowboy_options
  end

  post "/light_on" do
    digital_write(17, 1)
    send_resp(conn, 200, "The light is on!" |> web_page)
  end

  post "/light_off" do
    digital_write(17, 0)
    send_resp(conn, 200, "The light is off!" |> web_page)
  end

  get "/" do
    send_resp(conn, 200, "Hello" |> web_page)
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp digital_write(pin, value) do
    {:ok, pid} = Gpio.start_link(pin, :output)
    Gpio.write(pid, value)
    IO.puts "Wrote #{value} to pin #{pin}"
    Process.exit(pid, :normal)
    value
  end


  defp web_page(message) do
    """
    <html>
      <head>
        <title>Led thingy</title>
      </head>
      <body>
        <p>#{message}</p>
        <form action = "/light_on" method="post">
          <input type="submit" value="Turn light on"></input>
        </form>
        <form action = "/light_off" method="post">
          <input type="submit" value="Turn light off"></input>
        </form>
      </body>
    </html>
    """
  end
end
