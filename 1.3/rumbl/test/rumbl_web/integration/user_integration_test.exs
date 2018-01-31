defmodule RumblWebIntegrationTest do
  use RumblWeb.IntegrationCase, async: true

  @login_attrs %{username: "max", password: "password"}

  setup do
    user = insert_user(username: "max")
    conn = build_conn()
    conn = post(conn, session_path(conn, :create), session: @login_attrs)
    {:ok, conn: conn, user: user}
  end

  describe "User flow" do
    test "User page basic flow", %{conn: conn} do
      get(conn, user_path(conn, :index))
      |> follow_link("Users")
      |> assert_response(status: 200, path: user_path(conn, :index))
      |> follow_link("Videos")
      |> assert_response(status: 200, path: video_path(conn, :index))
    end

    #    test "Logout current user", %{conn: conn} do
    #      get(conn, user_path(conn, :index))
    #      |> follow_link("Logout")
    #      |> assert_response(status: 200, path: page_path(conn, :index))
    #    end
  end
end
