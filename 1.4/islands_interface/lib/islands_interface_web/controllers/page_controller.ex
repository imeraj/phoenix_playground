defmodule IslandsInterfaceWeb.PageController do
  use IslandsInterfaceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
