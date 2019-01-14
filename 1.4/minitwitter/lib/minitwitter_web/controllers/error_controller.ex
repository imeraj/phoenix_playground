defmodule MinitwitterWeb.ErrorController do
  use MinitwitterWeb, :controller

  def index(conn, _params) do
    render(conn, "404.html")
  end
end
