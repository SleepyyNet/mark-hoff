defmodule Markhoff.Commands do
  def handle_command(["deep" | tail], message) do
    IO.inspect(DateTime.utc_now)
    messages = Mixcord.Api.get_channel_messages!(message.channel_id, 100000, {})
    IO.inspect(DateTime.utc_now)
    IO.inspect "FINISHED GETTING MESSAGES"
    IO.inspect(DateTime.utc_now)
    Enum.each(messages, fn m ->
      {ok, time} = Timex.parse(m.timestamp, "{ISO:Extended}")
      message = %Messages.Message{message_id: m.id, user_id: m.author["id"], content: m.content, timestamp: time}
      Messages.Repo.insert(message)
    end)
    IO.inspect(DateTime.utc_now)
  end

  def handle_command(["build" | tail], message) do
    messages = Messages.Message |> Messages.Repo.all
    graph = Enum.reduce(messages, %{}, fn message, acc -> Markov.generate_graph(message.content, 2, acc) end)
    IO.inspect Map.keys(graph)
    sentence = Markov.traverse(graph, 20)
    IO.inspect(sentence)
  end
end