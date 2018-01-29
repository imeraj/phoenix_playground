defmodule RumblWeb.UserControllerTest do
  use RumblWeb.ConnCase

  alias Rumbl.Accounts

  @create_attrs %{name: "Meraj", username: "merajul", password: "password"}
  @invalid_attrs %{name: nil, username: nil, password: nil}

  @login_attrs %{username: "merajul", password: "password"}

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create/register user" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == user_path(conn, :index)

      conn = get(conn, user_path(conn, :index))
      assert html_response(conn, 200) =~ "User created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "show user" do
    test "display user information if login successful", %{conn: conn} do
      user = insert_user(@create_attrs)
      conn = post(conn, session_path(conn, :create), session: @login_attrs)

      assert redirected_to(conn) == user_path(conn, :index)

      conn = get(conn, user_path(conn, :show, user.id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "status code 401 (unauthenticated) if login fails", %{conn: conn} do
      user = insert_user(@create_attrs)

      conn = get(conn, user_path(conn, :show, user.id))
      assert conn.status == 401
    end
  end
end
