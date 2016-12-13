defmodule Markov do
  @corpus "I like cheese. I like butter. I don't like ham."

  def generate_graph(corpus, order, graph) when is_binary(corpus) do
    String.split(corpus) |> generate_graph(order, graph)
  end

  def generate_graph(corpus, order, graph) when length(corpus) > order do
    key = Enum.take(corpus, order)
    {:ok, value} = Enum.fetch(corpus, order)
    graph = add_to_graph(key, value, graph)
    generate_graph(Enum.drop(corpus, 1), order, graph)
  end

  def generate_graph(_corpus, _order, graph), do: graph

  def add_to_graph(key, value, graph) do
    current_values = Map.get(graph, key) || []
    Map.put(graph, key, current_values ++ [value])
  end

  def traverse(graph, 0, edges, chain), do: Enum.join(chain, " ")

  def traverse(graph, num, "") do
    {node, edges} = Enum.random(graph)
    traverse(graph, num - 1, length(node), node)
  end

  def traverse(graph, num, order, chain) do
    last_node = Enum.take(chain, -order)
    new_edge = [Enum.random(graph[last_node])]

    traverse(graph, num - 1, order, chain ++ new_edge)
  end

  def test() do
    IO.inspect g = generate_graph(@corpus, 3, %{})
    traverse(g, 3, "")
  end

end