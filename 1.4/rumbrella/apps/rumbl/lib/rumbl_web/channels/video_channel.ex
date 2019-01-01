defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias Rumbl.{
      Accounts,
      Multimedia
    }

  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Multimedia.get_video!(video_id)

    annotations =
      video
      |> Multimedia.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(RumblWeb.AnnotationView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    case Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast_annotation(socket, annotation, user)
        Task.start_link(fn -> compute_additional_info(annotation, socket) end)
          {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_annotation(socket, annotation, user) do
    broadcast!(socket, "new_annotation", %{
      id: annotation.id,
      user: RumblWeb.UserView.render("user.json", %{user: user}),
      body: annotation.body,
      at: annotation.at
    })
  end

  defp compute_additional_info(annotation, socket) do  
    for result <-
      InfoSys.compute(annotation.body, limit: 1, timeout: 10_000) do
        backend_user = Accounts.get_user_by(%{username: result.backend.name()})
        attrs = %{url: result.url, body: result.text, at: annotation.at}

        case Multimedia.annotate_video(backend_user, annotation.video_id, attrs) do
          {:ok, info_ann} -> broadcast_annotation(socket, info_ann, backend_user)
          {:error, _changeset} -> :ignore
        end
      end
  end
end
