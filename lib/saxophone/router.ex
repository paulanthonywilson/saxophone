defmodule Saxophone.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http Saxophone.Router, []
  end

  get "/" do
    send_resp(conn, 200, "Hello, I am working!")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
