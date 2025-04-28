defmodule D3bot.Router do
  use Plug.Router

  alias D3bot.{Replyer, MetaApi}

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
              "sender" => %{"id" => sender_id},
            }
          ],
        }
      ]
    } = body

    last_reply_id = get_last_reply_id(message_sender)
    {reply_text, reply_id} = Replyer.get_reply(message_text, last_reply_id)

    MetaApi.send_message(reply_text, sender_id)

    :ets.insert(:conversation_state, {message_sender, reply_id})

    send_resp(conn, 200, "ok")
  end

  def get_last_reply_id(message_sender) when is_binary(message_sender) do
    :conversation_state
    |> :ets.lookup(message_sender)
    |> get_last_reply_id()
  end

  def get_last_reply_id([{_message_sender, last_reply_id}]), do: last_reply_id

  def get_last_reply_id([]), do: nil

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
