defmodule PlateslateWeb.PageController do
  use PlateslateWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
