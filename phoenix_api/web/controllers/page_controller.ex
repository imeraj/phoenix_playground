defmodule PhoenixApi.PageController do
  use PhoenixApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
