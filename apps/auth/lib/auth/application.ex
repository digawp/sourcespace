defmodule Auth.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false 

    children = [
      supervisor(Auth.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Auth.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
