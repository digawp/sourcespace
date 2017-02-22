defmodule Auth.Application do
  @moduledoc """
    Describes the OTP application for this component.
    Start the Repo when application is started
  """
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
