defmodule Markhoff do
  use Application

  def start(_, _) do
    import Supervisor.Spec

    :ets.new(:parts, [:set, :public, :named_table])

    children = for i <- 1..System.schedulers_online, do: worker(MarkhoffConsumer, [], id: i)
    with_repo = children ++ [supervisor(Messages.Repo, [])]

    Supervisor.start_link(with_repo, strategy: :one_for_one)
  end

end
