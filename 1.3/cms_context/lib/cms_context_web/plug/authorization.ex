defmodule Authorization do
  import Plug.Conn
  import Phoenix.Controller
  import CmsContextWeb.Router.Helpers

  def require_existing_author(conn, _) do
    author = CmsContext.CMS.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end

  def authorize_page(conn, _) do
    page = CmsContext.CMS.get_page!(conn.params["id"])

    if conn.assigns.current_author.id == page.author_id do
      assign(conn, :page, page)
    else
      conn
      |> put_flash(:error, "You can't modify that page")
      |> redirect(to: cms_page_path(conn, :index))
      |> halt()
    end
  end
end
