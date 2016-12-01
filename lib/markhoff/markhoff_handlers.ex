defmodule Markhoff.Handlers do
  def handle_event({:MESSAGE_CREATE, message}, state) do
    case message.content do
      "PING" ->
        Mixcord.Api.create_message(message.channel_id, "PONG")
      "HELLO" ->
        Mixcord.Api.create_message(message.channel_id, "WORLD")
      _ ->
        Mixcord.Api.create_message(message.channel_id, ":>")
    end
  end

  def handle_event({event, _}, state) do
    IO.inspect(event)
  end
end

