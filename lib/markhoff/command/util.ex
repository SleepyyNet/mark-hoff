defmodule Markhoff.Command.Util do
  alias IEx.Helpers
  alias Nostrum.Api

  def ping(msg) do
    Api.create_message(msg.channel_id, "Pong")
  end

end
