defmodule RumblWeb.RoomChannel do
  @moduledoc false

  use RumblWeb, :channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_annotation", params, socket) do
    broadcast!(socket, "new_annotation", %{
      user: %{username: socket.assigns.user_id},
      body: params["body"],
      at: params["at"] |> Decimal.new() |> Decimal.round(4) |> Decimal.to_string()
    })

    {:reply, :ok, socket}
  end
end
