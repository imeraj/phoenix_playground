defmodule PlateslateWeb.Schema.Mutations.MenuItemsTest do
  use PlateslateWeb.ConnCase, async: true

  import Ecto.Query
  alias Plateslate.{Repo, Menu.Category}

  setup do
    Plateslate.Seeds.run()

    category_id =
      from(t in Category, where: t.name == "Sandwiches")
      |> Repo.one!()
      |> Map.fetch!(:id)

    {:ok, category_id: category_id}
  end

  @query """
  mutation ($menuItem: MenuItemInput!) {
    menuItemCreate(input: $menuItem) {
      name
      description
      price
    }
  }
  """

  test "menuItemCreate field creates an item", %{category_id: category_id} do
    menu_item = %{
      "name" => "French Dip",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id
    }

    conn = post build_conn(), "/api", query: @query, variables: %{menuItem: menu_item}

    assert json_response(conn, 200) == %{
             "data" => %{
               "menuItemCreate" => %{
                 "name" => menu_item["name"],
                 "description" => menu_item["description"],
                 "price" => menu_item["price"]
               }
             }
           }
  end

  test "creating a menu item with an existing name fails",
       %{category_id: category_id} do
    menu_item = %{
      "name" => "Reuben",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id
    }

    conn =
      post build_conn(), "/api",
        query: @query,
        variables: %{"menuItem" => menu_item}

    assert json_response(conn, 200) == %{
             "data" => %{"menuItemCreate" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 3, "line" => 2}],
                 "message" => "Could not create menu item",
                 "path" => ["menuItemCreate"],
                 "details" => %{"name" => ["has already been taken"]}
               }
             ]
           }
  end
end
