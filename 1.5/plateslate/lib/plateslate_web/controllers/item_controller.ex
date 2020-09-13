defmodule PlateslateWeb.ItemController do
  use PlateslateWeb, :controller

  use Absinthe.Phoenix.Controller, schema: PlateslateWeb.Schema, action: [mode: :internal]

  @graphql """
  query Index
  {
    menu_items @put {
      category
    }
  }
  """
  def index(conn, result) do
    render(conn, "index.html", items: result.data.menu_items)
  end
end
