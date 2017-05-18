defmodule Markhoff.Command.Util do
  alias Nostrum.Api

  def ping(msg) do
    Api.create_message(msg.channel_id, "Pong")
  end

  def inspect(msg, to_eval) do
    {val, _args} = Code.eval_string(to_eval)

    info =
      ["Term": val] ++
      IEx.Info.info(val) ++
      ["Implemented protocols": all_implemented_protocols_for_term(val)]

    embed = %{
      fields: for {subject, val} <- info do
        %{name: subject, value: val}
      end
    }

    Api.create_message(msg.channel_id, [content: "", embed: embed])
  end

  defp all_implemented_protocols_for_term(term) do
    :code.get_path()
    |> Protocol.extract_protocols()
    |> Enum.uniq()
    |> Enum.reject(fn(protocol) -> is_nil(protocol.impl_for(term)) end)
    |> Enum.map_join(", ", &inspect/1)
  end

end
