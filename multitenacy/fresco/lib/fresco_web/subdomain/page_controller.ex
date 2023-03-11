defmodule FrescoWeb.Subdomain.PageController do
  use FrescoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", %{subdomain: conn.private[:subdomain] || "fresco"})
  end
end
