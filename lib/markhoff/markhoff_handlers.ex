defmodule MarkhoffConsumer do
  use Mixcord.Shard.Dispatch.Consumer
  alias Mixcord.Api
  require Logger

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, {msg}, ws_state}, state) do
    case msg.content do
      <<"I>" :: binary, "ping" :: binary>> ->
        Api.create_message(msg.channel_id, "pong")
      _ ->
        :ignore
    end
  {:ok, state}
  end

  def handle_event(_, state) do
    {:ok, state}
  end
end
