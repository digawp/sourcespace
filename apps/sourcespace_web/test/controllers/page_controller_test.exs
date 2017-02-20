defmodule SourceSpaceWeb.PageControllerTest do
  use SourceSpaceWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "SourceSpace"
  end
end
