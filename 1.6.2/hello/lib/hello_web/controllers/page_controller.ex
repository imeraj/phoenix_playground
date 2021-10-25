defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  def index(conn, _params) do
    conn
    |> put_root_layout("admin.html")
    |> put_resp_content_type("text/html")
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> render(:index)
  end
end
