defmodule MinitwitterWeb.PageController do
  use MinitwitterWeb, :controller

  def home(conn, _params) do
    render(conn, "home.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end
end
