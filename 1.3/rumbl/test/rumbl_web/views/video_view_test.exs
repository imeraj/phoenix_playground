defmodule RumblWeb.VideoViewTest do
  use RumblWeb.ConnCase, async: true
  import Phoenix.View
  import RumblWeb.TestHelpers

  @valid_attrs %{
    category_id: 6,
    description: "Chris McCord | Keynote: Phoenix - Gauging Progress",
    title: "Chris McCord | Keynote: Phoenix - Gauging Progress",
    url: "https://www.youtube.com/watch?v=pfFpIjFOL-I"
  }

  @login_attrs %{username: "max", password: "password"}

  #  test "renders index.html", %{conn: conn} do
  #    user = insert_user(username: "max")
  #
  #    conn =
  #      build_conn()
  #      |> assign(:current_user, user)
  #
  #    IO.inspect(conn)
  #
  #    insert_video(user, @valid_attrs)
  #    insert_video(user, @valid_attrs)
  #    videos = Rumbl.Videos.list_videos()
  #
  #    content = render_to_string(RumblWeb.VideoView, "index.html", conn: conn, videos: videos)
  #
  #    assert String.contains?(content, "Listing Videos")
  #
  #    for video <- videos do
  #      assert String.contains?(content, video.title)
  #    end
  #  end
end
