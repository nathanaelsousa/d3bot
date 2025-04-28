defmodule D3botWeb.MetaController do

  alias D3botWeb.MetaApi
  alias D3bot.{Replyer, ConversationModel}

  @verfy_token "XR1VCwlS317X9Bf5xf1ZsDPo4WebcW1Tr"

  def webhook_get(params) do
    %{
      "hub.mode" => mode,
      "hub.verify_token" => token,
      "hub.challenge" => challenge,
    } = params

    webhook_get(mode, token, challenge)
  end

  def webhook_get("subscribe", @verfy_token, challenge) do
    {200, challenge}
  end

  def webhook_get(_mode, _token, _challenge) do
    {403, "Forbidden"}
  end

  def webhook_post(body) do
    {message_text, sender_id} = parse_post_body(body)

    {reply_text, reply_id} = sender_id
      |> ConversationModel.get()
      |> Replyer.get_reply(message_text)

    MetaApi.send_message(reply_text, sender_id)

    ConversationModel.save(sender_id, reply_id)

    {200, "ok"}
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
