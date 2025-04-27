
defmodule D3bot.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "blablablablaba")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
