defmodule SourceSpaceWeb do
  @moduledoc """
   The main application
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(SourceSpaceWeb.Repo, []),
      supervisor(SourceSpaceWeb.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: SourceSpaceWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    SourceSpaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
