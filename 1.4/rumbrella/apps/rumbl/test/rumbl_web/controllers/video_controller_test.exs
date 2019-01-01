defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase

  alias Rumbl.Multimedia

  defp video_count(user), do: Enum.count(Multimedia.list_user_videos(user))

  describe "without logged in user" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each([
        get(conn, Routes.video_path(conn, :new)),
        get(conn, Routes.video_path(conn, :index)),
        get(conn, Routes.video_path(conn, :show, "123")),
        get(conn, Routes.video_path(conn, :edit, "123")),
        put(conn, Routes.video_path(conn, :update, "123", %{})),
        post(conn, Routes.video_path(conn, :create, %{})),
        delete(conn, Routes.video_path(conn, :delete, "123")),
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
    end
  end

  describe "with a logged-in user" do
    @valid_attrs %{url: "http://youtu.be", title: "vid", description: "a vid", category_id: 1}
    @invalid_attrs %{title: "invalid"}

    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    @tag login_as: "max"
    test "lists all user's videos on index", %{conn: conn, user: user} do
      user_video = video_fixture(user, title: "video")
      other_video = video_fixture(user_fixture(username: "other"), title: "another video")

      conn = get conn, Routes.video_path(conn, :index)
      assert html_response(conn, 200) =~ ~r/Listing Videos/
      assert String.contains?(conn.resp_body, user_video.title)
      refute String.contains?(conn.resp_body, other_video.title)
    end

    @tag login_as: "max"
    test "does not create video and renders errors when invalid", %{conn: conn, user: user} do
      count_before = video_count(user)
      conn = post conn, Routes.video_path(conn, :create), video: @invalid_attrs
      assert html_response(conn, 200) =~ "check the errors"
      assert video_count(user) == count_before
    end

    @tag login_as: "max"
    test "authorizes actions against access by other users", %{conn: conn, user: user} do
      video = video_fixture(user)
      non_owner = user_fixture(username: "sneaky")
      conn = assign(conn, :current_user, non_owner)

      assert_error_sent :not_found, fn ->
        get(conn, Routes.video_path(conn, :show, video))
      end

      assert_error_sent :not_found, fn ->
        get(conn, Routes.video_path(conn, :edit, video)) end

      assert_error_sent :not_found, fn ->
        put(conn, Routes.video_path(conn, :update, video, video: @valid_attrs))
      end

      assert_error_sent :not_found, fn ->
        delete(conn, Routes.video_path(conn, :delete, video)) end
    end
  end
end

