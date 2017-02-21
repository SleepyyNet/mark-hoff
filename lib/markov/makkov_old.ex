defmodule MarkovOld do
  
  # For benchmarking purposes now
  def generate_graph(corpus, order, graph) when is_binary(corpus) do
    String.split(corpus) |> generate_graph(order, graph)
  end

  def generate_graph(corpus, order, graph) when length(corpus) > order do
    key = Enum.take(corpus, order)
    {:ok, value} = Enum.fetch(corpus, order)
    graph = add_to_graph(key, value, graph)
    generate_graph(Enum.drop(corpus, 1), order, graph)
  end

  def generate_graph(_corpus, _order, graph) do
    graph
  end

  def add_to_graph(key, value, graph) do
    current_values = Map.get(graph, key) || []
    Map.put(graph, key, current_values ++ [value])
  end

  def traverse(graph, _num) when map_size(graph) == 0,
    do: {:error, "received empty markov graph"}
  def traverse(graph, num) do
    {node, _edges} = Enum.random(graph)
    traverse(graph, num - 1, length(node), node)
  end

  def traverse(graph, _num, _seed) when map_size(graph) == 0,
    do: {:error, "received empty markov graph"}
  def traverse(graph, num, seed) do
    split_seed = String.split(seed)
    seed_length = length(split_seed)
    graph_order = graph
      |> Map.keys
      |> List.first
      |> length
    cond do
      graph_order != seed_length ->
        {:error, "expected seed of order #{graph_order}, received seed with order #{seed_length}"}
      graph[split_seed] == nil ->
        {:error, "seed #{seed} could not be found in markov graph"}
      graph_order == seed_length -> traverse(graph, num - 1, graph_order, split_seed)
    end
  end

  def traverse(_graph, 0, _edges, chain), do: {:ok, chain}
  def traverse(graph, num, order, chain) do
    last_node = Enum.take(chain, -order)
    case graph[last_node] do
      nil -> {:partial, chain}
      edges ->
        new_edge = [Enum.random(edges)]
        traverse(graph, num - 1, order, chain ++ new_edge)
    end
  end

  def build_string(chain, delim \\ ""), do: Enum.join(chain, delim)

  def test() do
    # g = generate_graph(@corpus, 1, %{})
    # traverse(g, 10, "like")
  end

end
