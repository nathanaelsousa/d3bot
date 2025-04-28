defmodule D3bot.ReplyerService do
  @reply_tree %{
    "reply1" => %{
      "text" => "Hello, choose option1 or option2.",
      "options" => %{
        "option1" => %{
          "kind" => "next",
          "reply_id" => "reply2"
        },
        "option2" => %{
          "kind" => "next",
          "reply_id" => "reply3"
        }
      }
    },
    "reply2" => %{
      "text" => "Ok, choose option3 or option4.",
      "options" => %{
        "option3" => %{
          "kind" => "finish",
          "text" => "Good bye."
        },
        "option4" => %{
          "kind" => "finish",
          "text" => "See you later."
        }
      }
    },
    "reply3" => %{
      "text" => "Ok, choose option5 or option6.",
      "options" => %{
        "option5" => %{
          "kind" => "finish",
          "text" => "So long."
        },
        "option6" => %{
          "kind" => "finish",
          "text" => "Bye."
        }
      }
    }
  }

  def get_reply(nil, _message_text) do
    option = %{"kind" => "next", "reply_id" => "reply1"}

    get_reply_response(option, nil)
  end

  def get_reply(last_reply_id, message_text) do
    @reply_tree
    |> get_in([last_reply_id, "options", message_text])
    |> get_reply_response(last_reply_id)
  end

  defp get_reply_response(%{"kind" => "next", "reply_id" => reply_id}, _last_reply_id) do
    text = @reply_tree[reply_id]["text"]

    {text, reply_id}
  end

  defp get_reply_response(%{"kind" => "finish", "text" => text}, _last_reply_id), do: {text, nil}

  defp get_reply_response(nil, last_reply_id), do: {"Try again.", last_reply_id}
end
