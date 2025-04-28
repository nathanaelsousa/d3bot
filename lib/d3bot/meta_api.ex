defmodule D3bot.MetaApi do

  @page_id 595509913653173
  @page_access_token System.get_env("PAGE_ACCESS_TOKEN")

  def send_message(text, recipient_id) do
    url = "https://graph.facebook.com/v22.0/#{@page_id}/messages?access_token=#{@page_access_token}"
    headers = [{"Content-Type", "application/json"}]
    body = JSON.encode!(%{
      "recipient" => %{
        "id" => recipient_id
      },
      "messaging_type" =>  "RESPONSE",
      "message" => %{
        "text" => text
      }
    })

    HTTPoison.post!(url, body, headers)
  end
end
