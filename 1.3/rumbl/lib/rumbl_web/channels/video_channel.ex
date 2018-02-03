defmodule RumblWeb.RoomChannel do
  @moduledoc false

  import Ecto.Query

  use RumblWeb, :channel

  import Ecto

  alias Rumbl.Repo
  alias Rumbl.Videos.Annotation

  def join("videos:" <> video_id, _params, socket) do
    IO.inspect("joined")
    {:ok, assign(socket, :video_id, String.to_integer(video_id))}
  end

  def handle_in(event, params, socket) do
    IO.inspect("here")
    user = Rumbl.Accounts.get_user(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    IO.inspect("here 1")

    changeset =
      user
      |> build_assoc(:annotations, video_id: socket.assigns.video_id)
      |> Annotation.changeset(params)
      |> IO.inspect()

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          user: RumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
