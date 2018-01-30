defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Videos
  alias Rumbl.Videos.Video

  import Rumbl.Auth, only: [load_current_user: 2]

  plug(:load_current_user)
  plug(:authorize_video when action in [:edit, :update, :delete])
  plug(:load_categories when action in [:new, :create, :edit, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _user) do
    videos = Videos.list_videos()
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, user) do
    changeset = Videos.change_video(%Video{}, %{}, user)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    case Videos.create_video(video_params, user) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    changeset = Ecto.Changeset.change(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Videos.get_video!(id)

    case Videos.update_video(video, video_params, user) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp authorize_video(conn, _) do
    video = Rumbl.Videos.get_video!(conn.params["id"])

    if conn.assigns.current_user.id == video.user_id do
      assign(conn, :video, video)
    else
      conn
      |> put_flash(:error, "You don't have authorization for this operation!")
      |> redirect(to: video_path(conn, :index))
      |> halt()
    end
  end

  defp load_categories(conn, _) do
    categories = Rumbl.Videos.load_categories()
    assign(conn, :categories, categories)
  end
end
