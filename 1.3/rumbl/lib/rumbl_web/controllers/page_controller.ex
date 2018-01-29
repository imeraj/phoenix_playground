defmodule RumblWeb.PageController do
  use RumblWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
