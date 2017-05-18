defmodule Markhoff.Consumer do
  use Nostrum.TaskedConsumer

  alias Markhoff.Command

  def start_link do
    TaskedConsumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, {msg}, _ws_state}) do
    Command.handle(msg)
  end

  def handle_event(_) do
    :noop
  end
end
