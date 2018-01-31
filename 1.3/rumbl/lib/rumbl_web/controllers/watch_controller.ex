defmodule RumblWeb.WatchController do
  @moduletag false

  use RumblWeb, :controller

  alias(Rumbl.Videos)

  import Rumbl.Auth, only: [load_current_user: 2]

  plug(:load_current_user)

  def show(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    render(conn, "show.html", video: video)
  end
end
