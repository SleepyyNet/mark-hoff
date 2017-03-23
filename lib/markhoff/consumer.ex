defmodule Markhoff.Consumer do
  use Nostrum.Consumer

  alias Markhoff.Command

  @prefix "I>"

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, {msg}, ws_state}, state) do
    with @prefix <> rest <- msg.content,
    do: Task.start fn -> Command.handle(msg, rest) end

    {:ok, state}
  end

  def handle_event(_, state) do
    {:ok, state}
  end
end
