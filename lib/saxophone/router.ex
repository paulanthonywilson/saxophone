defmodule Saxophone.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_link do
    cowboy_options = Application.get_env(:saxophone, :cowboy_options)
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [], cowboy_options
  end

  get "/" do
    send_resp(conn, 200, "Hello, I am working!")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
