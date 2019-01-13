defmodule MinitwitterWeb.SessionControllerTest do
  use MinitwitterWeb.ConnCase

  test "should get new", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "Log in"
  end
end
