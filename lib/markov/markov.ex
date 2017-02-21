defmodule Markov do

  def generate_graph(corpus, order) when is_binary(corpus) do
    String.split(corpus) |> generate_graph(order)
  end

  def generate_graph(corpus, order) when length(corpus) > order do
    Task.start(fn ->
      [key] = Enum.take(corpus, order)
      {:ok, value} = Enum.fetch(corpus, order)
      add_to_graph(key, value)
    end)
    generate_graph(Enum.drop(corpus, 1), order)
  end

  def generate_graph(_, _), do: :ok

  def add_to_graph(key, value) do
    case :ets.lookup(:parts, key) do
      [] ->
        :ets.insert(:parts, {key, [value]})
      [{^key, values}] ->
        values = values ++ [value]
        :ets.insert(:parts, {key, values})
    end
  end

  def traverse(key, parts) do
    case :ets.lookup(:parts, key) do
      [] ->
        parts
      [{^key, values}] ->
        value = Enum.random(values)
        traverse(value, parts ++ [value])
    end
  end

  def build_string(chain, delim \\ ""), do: Enum.join(chain, delim)
end
