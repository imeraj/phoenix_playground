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
      ... on Errors {
       errors {
          key
          message
        }
      }

      ... on MenuItem {
    	  name
    	  description
    	  price
      }
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

    user = Factory.create_user("employee")
    conn = build_conn() |> auth_user(user)
    conn = post conn, "/api", query: @query, variables: %{menuItem: menu_item}

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

    user = Factory.create_user("employee")
    conn = build_conn() |> auth_user(user)

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"menuItem" => menu_item}

    assert json_response(conn, 200) == %{
             "data" => %{
               "menuItemCreate" => %{
                 "errors" => [%{"key" => "name", "message" => "has already been taken"}]
               }
             }
           }
  end

  defp auth_user(conn, user) do
    token = PlateslateWeb.Graphql.Authentication.sign(%{role: user.role, id: user.id})
    put_req_header(conn, "authorization", "Bearer #{token}")
  end
end
