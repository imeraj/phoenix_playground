defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

	alias Rumbl.TestHelpers

  @valid_attrs %{description: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

	defp video_count(query), do: Repo.one(from v in query, select: count(v.id))

	setup %{conn: conn} = config do
		if username = config[:login_as] do
	    user = TestHelpers.insert_user(%{username: username})
	    conn = assign(build_conn(), :current_user, user)
	    {:ok, conn: conn, user: user}
	  else
	   :ok
	  end
	end

	test "requires user authentication on all actions" do
	  Enum.each([
	    get(build_conn(), video_path(build_conn(), :new)),
	    get(build_conn(), video_path(build_conn(), :index)),
	    get(build_conn(), video_path(build_conn(), :show, "123")),
	    get(build_conn(), video_path(build_conn(), :edit, "123")),
	    put(build_conn(), video_path(build_conn(), :update, "123", %{})),
	    post(build_conn(), video_path(build_conn(), :create, %{})),
	    delete(build_conn(), video_path(build_conn(), :delete, "123"))
	  ], fn conn ->
			assert html_response(conn, 302)
			assert conn.halted
	   end)
	end

	@tag login_as: "max"
	test "lists all user's videos on index", %{conn: conn, user: user} do
		user_video = TestHelpers.insert_video(user, @valid_attrs)
		other_video = TestHelpers.insert_video(insert_user(%{username: "other"}),
									%{title: "funny cats"})

		conn = get(conn, video_path(conn, :index))
		assert html_response(conn, 200) =~ ~r/Listing videos/
		assert String.contains?(conn.resp_body, user_video.title)
		refute String.contains?(conn.resp_body, other_video.title)
	end

	@tag login_as: "max"
	test "does not create video and renders erros when invalid", %{conn: conn} do
		count_before = video_count(Rumbl.Video)
		conn = post conn, video_path(conn, :create), video: @invalid_attrs

		assert html_response(conn, 200) =~ "check the errors"
		count_after = video_count(Rumbl.Video)
		assert count_after == count_before
	end
end

