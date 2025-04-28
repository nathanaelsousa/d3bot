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

  get "/webhook" do
    %{query_params: params} = fetch_query_params(conn)

    {status, body} = MetaController.webhook_get(params)
    encoded_body = JSON.encode!(body)

    send_resp(conn, status, encoded_body)
  end

  post "/webhook" do
    {status, body} = MetaController.webhook_post(conn.body_params)
    encoded_body = JSON.encode!(body)

    send_resp(conn, status, encoded_body)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
