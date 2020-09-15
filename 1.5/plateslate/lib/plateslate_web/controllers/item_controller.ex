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

  @graphql """
  query ($id: ID!, $since: Date) {
    menu_item(input: {
      id: $id
    }) @put {
      order_history(since: $since) {
        orders
        quantity
        gross
      }
    }
  }
  """
  def show(conn, %{data: %{menu_item: nil}}) do
    conn
    |> put_flash(:info, "Menu item not found")
    |> redirect(to: "/admin/items")
  end

  def show(conn, %{data: %{menu_item: item}}) do
    since = variables(conn)["since"]
    render(conn, "show.html", item: item, since: since)
  end
end
