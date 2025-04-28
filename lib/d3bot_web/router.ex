defmodule D3botWeb.Router do
  use Plug.Router

  alias D3botWeb.MetaController

  plug Plug.Logger
  plug Plug.Parsers,
    parsers: [:json],
    pass:  ["application/json"],
    json_decoder: JSON
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "ok")
  end

  match "/webhook", to: MetaController

  match _ do
    send_resp(conn, 404, "not found")
  end
end
