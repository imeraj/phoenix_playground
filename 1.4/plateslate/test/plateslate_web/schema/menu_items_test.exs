defmodule PlateslateWeb.Schema.Query.MenuItemsTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  @query """
  {
    menuItems {
      name
    }
  }
  """

  test "menuItems field returns menu items" do
    conn = build_conn()
    conn = get(conn, "/graphiql", query: @query)

    assert json_response(conn, 200) ==
      %{
        "data" => %{
          "menuItems" => [
            %{"name" => "Reuben"},
            %{"name" => "Croque Monsieur"},
            %{"name" => "Muffuletta"},
            %{"name" => "Bánh mì"},
            %{"name" => "Vada Pav"},
            %{"name" => "French Fries"},
            %{"name" => "Papadum"},
            %{"name" => "Pasta Salad"},
            %{"name" => "Water"},
            %{"name" => "Soft Drink"},
            %{"name" => "Lemonade"},
            %{"name" => "Masala Chai"},
            %{"name" => "Vanilla Milkshake"},
            %{"name" => "Chocolate Milkshake"}
          ]
        }
      }
  end
end
