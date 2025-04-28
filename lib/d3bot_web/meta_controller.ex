defmodule D3botWeb.MetaController do
  @behaviour Plug

  import Plug.Conn

  alias D3botWeb.MetaApi
  alias D3bot.{Replyer, ConversationModel}

  @verfy_token "XR1VCwlS317X9Bf5xf1ZsDPo4WebcW1Tr"

  def init(opts) do
    opts
  end

   def call(conn = %Plug.Conn{method: "GET"}, _opts) do
    %{query_params: params} = fetch_query_params(conn)
    %{
      "hub.mode" => mode,
      "hub.verify_token" => token,
      "hub.challenge" => challenge,
    } = params

    webhook_get(conn, mode, token, challenge)
  end

  def call(conn = %Plug.Conn{method: "POST"}, _opts) do
    {message_text, sender_id} = parse_post_body(conn.body_params)

    {reply_text, reply_id} = sender_id
      |> ConversationModel.get()
      |> Replyer.get_reply(message_text)

    MetaApi.send_message(reply_text, sender_id)

    ConversationModel.save(sender_id, reply_id)

    send_resp(conn, 200, "ok")
  end

  def webhook_get(conn, "subscribe", @verfy_token, challenge) do
    send_resp(conn, 200, challenge)
  end

  def webhook_get(conn, _mode, _token, _challenge) do
    send_resp(conn, 403, "Forbidden")
  end

  def parse_post_body(body) do
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

    {message_text, sender_id}
  end
end
