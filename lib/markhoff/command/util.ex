defmodule Markhoff.Command.Util do
  alias Nostrum.Api

  require Logger

  def ping(msg) do
    Api.create_message(msg.channel_id, "Pong")
  end

  def help(_msg, method) do
    method
    |> mfa_from_string
    |> get_docs
    #|> print_docs
  end

  defp get_docs({m, f, a}) do
    
  end

  defp mfa_from_string(str) do
    str
    |> Code.string_to_quoted!
    |> Macro.decompose_call
    |> mfa_from_ast
  end

  @h_modules [__MODULE__, Kernel, Kernel.SpecialForms]

  defp mfa_from_ast(ast) do
    case ast do
      # Enum
      {:__aliases__, modules} -> {Module.concat(modules)}
      # Enum.random & Enum.random [1,2,3]
      {{:__aliases__, _, modules}, fun, args} -> 
        {Module.concat(modules), fun, length(args)}
      # 1 + 2
      {fun, [args]} ->
        {@h_modules, fun, length(args)}
      # Enum.random/1, yikes
      {:/, [{{:., _, [{:__aliases__, _, modules}, fun]}, _, []}, arity]} -> 
        {Module.concat(modules), fun, arity}
    end
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

    Api.create_message(msg, [content: "", embed: embed])
  end

  defp all_implemented_protocols_for_term(term) do
    :code.get_path()
    |> Protocol.extract_protocols()
    |> Enum.uniq()
    |> Enum.reject(fn(protocol) -> is_nil(protocol.impl_for(term)) end)
    |> Enum.map_join(", ", &inspect/1)
  end

end