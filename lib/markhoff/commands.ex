defmodule Markhoff.Commands do
  def deep(id) do
    messages = Mixcord.Api.get_channel_messages!(id, 100000, {})
    Enum.each(messages, fn m ->
      if not m.author.bot do
        {ok, time} = Timex.parse(m.timestamp, "{ISO:Extended}")
        message = %Messages.Message{message_id: m.id, user_id: m.author["id"], content: m.content, timestamp: time}
        Messages.Repo.insert(message)
      end
    end)
  end

  def handle_command(:build, message) do
    messages = Messages.Message |> Messages.Repo.all
    do_work_ets_store(messages)
  end

  def do_work_ets_store(messages) do
    Task.async_stream(messages, &insert_to_ets(&1))
      |> Enum.take 100000
  end

  def insert_to_ets(corpus) do
    Markov.generate_graph(corpus.content, 1)
  end
end
