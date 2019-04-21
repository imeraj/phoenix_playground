defmodule GithubLiveviewWeb.PageController do
  use GithubLiveviewWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, GithubLiveviewWeb.GithubDeployView, session: %{})
  end
end
