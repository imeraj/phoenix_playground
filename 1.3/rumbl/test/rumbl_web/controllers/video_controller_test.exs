defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase

  import Ecto.Query

  alias Rumbl.Videos.Video
  alias Rumbl.Repo

  defp video_count(query), do: Repo.one(from(v in query, select: count(v.id)))

  @login_attrs %{username: "max", password: "password"}

  @valid_attrs %{
    category_id: 6,
    description: "Chris McCord | Keynote: Phoenix - Gauging Progress",
    title: "Chris McCord | Keynote: Phoenix - Gauging Progress",
    url: "https://www.youtube.com/watch?v=pfFpIjFOL-I"
  }

  @invalid_attrs %{title: "Invalid"}

  setup do
    user = insert_user(username: "max")
    conn = build_conn()
    conn = post(conn, session_path(conn, :create), session: @login_attrs)
    {:ok, conn: conn, user: user}
  end

  describe "user authentiation" do
    test "require user authentication for all actions", %{conn: _conn} do
      Enum.each(
        [
          get(build_conn(), video_path(build_conn(), :new)),
          get(build_conn(), video_path(build_conn(), :index)),
          get(build_conn(), video_path(build_conn(), :show, "123")),
          get(build_conn(), video_path(build_conn(), :edit, "123")),
          put(build_conn(), video_path(build_conn(), :update, "123", %{})),
          post(build_conn(), video_path(build_conn(), :create, %{})),
          delete(build_conn(), video_path(build_conn(), :delete, "123"))
        ],
        fn conn ->
          assert conn.status == 401
        end
      )
    end

    test "list all user videos on index", %{conn: conn, user: user} do
      user_video = insert_video(user, @valid_attrs)

      conn = get(conn, video_path(conn, :index))
      assert html_response(conn, 200) =~ ~r/Listing Videos/
      assert String.contains?(conn.resp_body, user_video.title)
    end

    test "does not create video and renders errors when invalid", %{conn: conn} do
      count_before = video_count(Video)
      conn = post(conn, video_path(conn, :create), video: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Video"
      assert video_count(Video) == count_before
    end
  end
end
