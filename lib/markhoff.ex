defmodule Markhoff do
  use Application

  def start(_, _) do
    import Supervisor.Spec

    children = [
      supervisor(Messages.Repo, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
