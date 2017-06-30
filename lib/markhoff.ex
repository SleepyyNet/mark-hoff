defmodule Markhoff do
  use Application

  alias Markhoff.Consumer

  def start(_, _) do
    import Supervisor.Spec

    :ets.new(:parts, [:set, :public, :named_table])

    children = for i <- 1..System.schedulers_online, do: worker(Consumer, [], id: i)

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
