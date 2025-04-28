defmodule D3botWeb.MetaController do
  @behaviour Plug

  import Plug.Conn

  alias D3botWeb.MetaApi
  alias D3bot.{ReplyerService, ConversationModel}

  @verfy_token "XR1VCwlS317X9Bf5xf1ZsDPo4WebcW1Tr"

  def init(opts) do
    opts
  end

   def call(conn = %Plug.Conn{method: "GET"}, _opts) do
    %{
      query_params: %{
        "hub.mode" => mode,
        "hub.verify_token" => token,
        "hub.challenge" => challenge,
      }
    } = fetch_query_params(conn)

    get_verify_response(conn, mode, token, challenge)
  end

  def call(conn = %Plug.Conn{method: "POST"}, _opts) do
    {message_text, sender_id} = parse_post_body(conn.body_params)

    {reply_text, reply_id} = sender_id
      |> ConversationModel.get()
      |> ReplyerService.get_reply(message_text)

    MetaApi.send_message(reply_text, sender_id)

    ConversationModel.save(sender_id, reply_id)

    send_resp(conn, 200, "ok")
  end

  defp get_verify_response(conn, "subscribe", @verfy_token, challenge) do
    send_resp(conn, 200, challenge)
  end

  defp get_verify_response(conn, _mode, _token, _challenge) do
    send_resp(conn, 403, "Forbidden")
  end

  defp parse_post_body(body) do
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
