defmodule FrescoWeb.PageController do
  use FrescoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
