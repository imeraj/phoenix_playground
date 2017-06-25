defmodule Rumbl.Channels.UserSocketTest do
  @moduledoc false

	use Rumbl.ChannelCase, async: true
	alias Rumbl.UserSocket

	test "socket authentication with valid token" do
		token = Phoenix.Token.sign(@endpoint, "user socket", "123")

		assert {:ok, socket} = Phoenix.ChannelTest.connect(UserSocket, %{"token" => token})
		assert socket.assigns.user_id == "123"
	end

	test "socket authentication with invalid token" do
		assert :error = Phoenix.ChannelTest.connect(UserSocket, %{"token" => "1234"})
		assert :error = Phoenix.ChannelTest.connect(UserSocket, %{})
	end

end
