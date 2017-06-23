defmodule Rumbl.WatchController do
  use Rumbl.Web, :controller
  alias Rumbl.Video

	plug :authenticate_user when action in [:show]

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render conn, "show.html", video: video
  end

end
