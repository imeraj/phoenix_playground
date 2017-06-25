defmodule Rumbl.Channels.VideoChannelTest do
  @moduledoc false

	import Rumbl.TestHelpers

	alias Rumbl.UserSocket
	use Rumbl.ChannelCase

	setup do
		user = insert_user(%{name: "Rebecca"})
		insert_video(user, title: "Testing")
		video = Repo.one(from v in Rumbl.Video, order_by: [desc: v.id], limit: 1)

		token = Phoenix.Token.sign(@endpoint, "user socket", user.id)
		{:ok, socket} = connect(UserSocket, %{"token" => token})
		{:ok, socket: socket, user: user, video: video}
	end

	test "join replies with video annotations", %{socket: socket, video: video} do
		for body <- ~w(one two) do
		  video
		  |> build_assoc(:annotations, %{body: body})
		  |> Repo.insert!()
		end

		{:ok, reply, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})

		assert socket.assigns.video_id == video.id
		assert %{annotations: [%{body: "one"}, %{body: "two"}]} = reply
	end

	test "inserting new annotations", %{socket: socket, video: video} do
	  {:ok, _, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})
	  ref = push socket, "new_annotation", %{body: "the body", at: 0}
	  assert_reply ref, :ok, %{}
	  assert_broadcast "new_annotation", %{}
	end

end
