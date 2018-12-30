defmodule RumblWeb.AuthTest do
  use RumblWeb.ConnCase
  alias RumblWeb.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(RumblWeb.Router, :browser) |> get("/")
    {:ok, %{conn: conn}}
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])

    assert conn.halted
  end

  test "authenticate_user continues when the current_user exists", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %Rumbl.Accounts.User{})
      |> Auth.authenticate_user([])

    refute conn.halted
  end

  test "login puts the user in the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%Rumbl.Accounts.User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 123
  end

  test "logout drops the session", %{conn: conn} do
    login_conn =
      conn
      |> put_session(:user_id, 123)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  test "call places user from session into assigns", %{conn: conn} do
    user = user_fixture()
    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Auth.init([]))

    assert conn.assigns.current_user.id == user.id
  end

  test "call with no session sets current_user assign to nil", %{conn: conn} do
    conn =
      conn
      |> Auth.call(Auth.init([]))

    assert conn.assigns.current_user == nil
  end

  test "login with a valid username and pass", %{conn: conn} do
    user = user_fixture(username: "me1", email: "me@test", password: "secret")

    {:ok, conn} =
      conn
      |> Auth.login_by_email_and_pass("me@test", "secret")

    assert conn.assigns.current_user.id == user.id
  end

  test "login with a not found user", %{conn: conn} do
    assert {:error, :not_found, _conn} =
      conn
      |> Auth.login_by_email_and_pass("me@test", "secret")
  end

  test "login with password mismatch", %{conn: conn} do
    _ = user_fixture(username: "me1", email: "me@test", password: "secret")
    assert {:error, :unauthorized, _conn} =
      conn
      |> Auth.login_by_email_and_pass("me@test", "wrongpass")
  end
end