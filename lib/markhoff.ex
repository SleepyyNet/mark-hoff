defmodule Markhoff do
  use Application

  def start(_, _) do
    import Supervisor.Spec

    :ets.new(:maps, [:set, :public, :named_table])
    :ets.insert(:maps, {"map", %{}})

    children = [
      supervisor(Messages.Repo, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
