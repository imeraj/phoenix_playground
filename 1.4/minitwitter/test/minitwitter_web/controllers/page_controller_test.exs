defmodule MinitwitterWeb.PageControllerTest do
  use MinitwitterWeb.ConnCase

  setup do
    {:ok, base_title: "Minitwitter Phoenix App"}
  end

  test "should get root", %{conn: conn, base_title: base_title} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Minitwitter App"
      assert html_response(conn, 200) =~ "Home | #{base_title}"
  end

  test "should get home", %{conn: conn, base_title: base_title} do
    conn = get(conn, Routes.page_path(conn, :home))
    assert html_response(conn, 200) =~ "Minitwitter App"
    assert html_response(conn, 200) =~ "Home | #{base_title}"
  end

  test "should get help", %{conn: conn, base_title: base_title} do
      conn = get(conn, Routes.page_path(conn, :help))
      assert html_response(conn, 200) =~ "Meraj"
      assert html_response(conn, 200) =~ "Help | #{base_title}"
  end
end
