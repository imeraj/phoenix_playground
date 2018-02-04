defmodule RumblWeb.Channels.VideoChannelTest do
  @moduledoc false

  import RumblWeb.TestHelpers
  import Ecto.Query

  use RumblWeb.ChannelCase

  alias RumblWeb.UserSocket
  alias Rumbl.Videos.Video

  @valid_attrs %{
    category_id: 6,
    description: "Chris McCord | Keynote: Phoenix - Gauging Progress",
    title: "Chris McCord | Keynote: Phoenix - Gauging Progress",
    url: "https://www.youtube.com/watch?v=pfFpIjFOL-I",
    slug: Video.slugify("Chris McCord | Keynote: Phoenix - Gauging Progress")
  }

  setup do
    user = insert_user(%{name: "Rebecca"})
    insert_video(user, @valid_attrs)
    video = Repo.one(from(v in Video, order_by: [desc: v.id], limit: 1))

    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)
    {:ok, socket} = connect(UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user, video: video}
  end

  describe "annotations test" do
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
      ref = push(socket, "new_annotation", %{body: "the body", at: 0})
      assert_reply(ref, :ok, %{})
      assert_broadcast("new_annotation", %{})
    end
  end
end
