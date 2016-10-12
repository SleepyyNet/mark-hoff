defmodule Mixbot.Handlers do
  def handle_event({:MESSAGE_CREATE, payload}) do
    IO.inspect(payload)
  end

  def handle_event({_, _}) do
    IO.inspect("OTHER")
  end
end

