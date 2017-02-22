defmodule SourceSpaceWeb.UserController do
  use SourceSpaceWeb.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated,
    [handler: __MODULE__, typ: "access"] when action in [:edit]

  def new(conn, _params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end

  def edit(conn, _params, current_user, _claims) do
    render conn, "edit.html", current_user: current_user
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login))
  end
end
