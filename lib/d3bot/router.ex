defmodule D3bot.Router do
  use Plug.Router

  alias D3bot.Replyer

  plug Plug.Logger
  plug :match
  plug :dispatch

  @verfy_token "XR1VCwlS317X9Bf5xf1ZsDPo4WebcW1Tr"
  @page_access_token System.get_env("PAGE_ACCESS_TOKEN")
  @page_id 595509913653173

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
    body = JSON.decode!(body_raw)

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

    reply_text = Replyer.get_reply(message_text, nil)

    IO.inspect({message_sender})

    body = %{
      "recipient" => %{
        "id" => "9559729030790410"
      },
      "messaging_type" =>  "RESPONSE",
      "message" => %{
        "text" => reply_text
      }
    }
    headers = [{"Content-Type", "application/json"}]

    HTTPoison.post!(
      "https://graph.facebook.com/v22.0/#{@page_id}/messages?access_token=#{@page_access_token}",
      JSON.encode!(body),
      headers
    )

    send_resp(conn, 200, "bla")
  end

  get "/test" do
    body = %{
      "recipient" => %{
        "id" => "9559729030790410"
      },
      "messaging_type" =>  "RESPONSE",
      "message" => %{
        "text" => "Hello, world!"
      }
    }
    headers = [{"Content-Type", "application/json"}]

    bla = HTTPoison.post!(
      "https://graph.facebook.com/v22.0/#{@page_id}/messages?access_token=#{@page_access_token}",
      JSON.encode!(body),
      headers
    )

    IO.inspect(bla)

    send_resp(conn, 200, "bla")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
