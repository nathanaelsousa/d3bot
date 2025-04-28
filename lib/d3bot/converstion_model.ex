defmodule D3bot.ConversationModel do
  @table_id :conversation_state

  def save(sender_id, reply_id) do
    :ets.insert(@table_id, {sender_id, reply_id})
  end

  def get(sender_id) when is_binary(sender_id) do
    @table_id
    |> :ets.lookup(sender_id)
    |> get()
  end

  def get([{_sender_id, last_reply_id}]), do: last_reply_id

  def get([]), do: nil
end
