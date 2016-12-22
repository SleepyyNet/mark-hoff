defmodule Markhoff.Handlers do

  def handle_event({:MESSAGE_CREATE, message}, _state) do
    case message.content do
      <<"I>" :: binary, rest :: binary>> ->
        Task.start fn ->
          rest
          |> String.split(" ")
          |> Markhoff.Commands.handle_command(message)
        end
      other ->
        :ignore
    end
  end

  def handle_event({event, _}, _state) do
    #IO.inspect(event)
  end
end

