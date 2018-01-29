defmodule RumblWeb.SessionControllerTest do
  use RumblWeb.ConnCase

  @login_attrs %{username: "meraj", password: "password"}
  @invalid_attrs %{username: nil, password: nil}

  setup do
    user = insert_user()
    {:ok, conn: build_conn(), user: user}
  end

  describe "Log in user" do
    test "redirects to index when login successful", %{conn: conn} do
      conn = post(conn, session_path(conn, :create), session: @login_attrs)
      assert redirected_to(conn) == user_path(conn, :index)

      conn = get(conn, user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "renders errors when login failed", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "Log out user" do
    test "redirects to home page when logout successful", %{conn: conn, user: user} do
      conn = post(conn, session_path(conn, :create), session: @login_attrs)
      assert redirected_to(conn) == user_path(conn, :index)

      conn = delete(conn, session_path(conn, :delete, user.id))
      assert conn.status == 302
      assert redirected_to(conn) == "/"
    end
  end
end
