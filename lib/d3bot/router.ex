defmodule D3bot.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  @verfy_token "XR1VCwlS317X9Bf5xf1ZsDPo4WebcW1Tr"

  get "/" do
    send_resp(conn, 200, "3412349812347982374")
  end

  get "/webhook" do
    %{query_params: params} = conn
      |> fetch_query_params()

    mode = Access.get(params, "hub.mode")
    token = Access.get(params, "hub.verify_token")
    challenge = Access.get(params, "hub.challenge")

    if mode && token do
      if mode == "subscribe" && token == @verfy_token do
        send_resp(conn, 200, challenge)
      else
        send_resp(conn, 403, "Forbidden")
      end
    end
  end

  post "/webhook" do
    {:ok, body_raw, conn} = Plug.Conn.read_body(conn)

    {:ok, body} = JSON.decode(body_raw)

    %{
      "entry" => [
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => message_text
              },
              "sender" => %{"id" => message_sender},
            }
          ],
        }
      ]
    } = body

    IO.inspect({message_text, message_sender})

    send_resp(conn, 200, "bla")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
