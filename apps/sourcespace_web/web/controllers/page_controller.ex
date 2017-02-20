defmodule SourceSpaceWeb.PageController do
  use SourceSpaceWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
