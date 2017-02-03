defmodule Markhoff.Commands do
  #def handle_command(["deep" | tail], message) do
  #  IO.inspect(DateTime.utc_now)
  #  messages = Mixcord.Api.get_channel_messages!(message.channel_id, 100000, {})
  #  IO.inspect(DateTime.utc_now)
  #  IO.inspect "FINISHED GETTING MESSAGES"
  #  IO.inspect(DateTime.utc_now)
  #  Enum.each(messages, fn m ->
  #    if not m.author.bot do
  #      {ok, time} = Timex.parse(m.timestamp, "{ISO:Extended}")
  #      message = %Messages.Message{message_id: m.id, user_id: m.author["id"], content: m.content, timestamp: time}
  #      Messages.Repo.insert(message)
  #    end
  #  end)
  #  IO.inspect(DateTime.utc_now)
  #end

  def handle_command(["build" | tail], message) do
    messages = Messages.Message |> Messages.Repo.all
    graph = do_work_ets_store(messages)
    #seed = Enum.take(tail, 1) |> Enum.join(" ")
    #case Markov.traverse(graph, 20, seed) do
    #  {:error, _} -> :noop
    #  {_, sentence_parts} ->
    #    Mixcord.Api.create_message(message.channel_id, Enum.join(sentence_parts, " "))
    #end
  end

  def do_work(messages) do
    graph = Enum.reduce(messages, %{}, fn message, acc -> Markov.generate_graph(message.content, 1, acc) end)
  end

  def do_work_ets_store(messages) do
    IO.inspect("BEFORE")
    Task.async_stream(messages, &insert_to_ets(&1))
      |> Enum.take 100000
    IO.inspect("AFTER")
  end

  def do_work_ets_lookup do

  end

  def insert_to_ets(value) do
    #exists = :ets.member(:maps, key)
    #if exists do
    IO.inspect(value.content)
    old = :ets.lookup_element(:maps, "map", 2)
    test = Markov.generate_graph(value.content, 1, old)
    :ets.update_element(:maps, "map", {2, test})
    #else
    #  :ets.insert(:maps, {key, value})
    #end
  end
end