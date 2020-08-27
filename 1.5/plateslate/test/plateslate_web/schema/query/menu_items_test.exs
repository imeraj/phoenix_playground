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

  test "menuItems field returns menuItems" do
    conn = build_conn()
    conn = get(conn, "/api", query: @query)

    assert json_response(conn, 200) == %{
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

  @query """
    query ($term: String) {
      menuItems(matching: $term) {
      name
    }
  }
  """

  @variables %{"term" => "reu"}
  test "menuItems field returns menu items filtered by name" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert json_response(response, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{"name" => "Reuben"}
               ]
             }
           }
  end

  @query """
  {
    menuItems(matching: 123) {
      name
    }
  }
  """

  test "menuItems field returns errors when using a bad value" do
    response = get(build_conn(), "/api", query: @query)
    assert %{"errors" => [%{"message" => message}]} = json_response(response, 200)
    assert message == "Argument \"matching\" has invalid value 123."
  end

  @query """
  {
    menuItems(order: DESC) {
      name
    }
  }
  """

  test "menuItems field returns items descending using literals" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{
               "menuItems" => [%{"name" => "Water"} | _]
             }
           } = json_response(response, 200)
  end
end
