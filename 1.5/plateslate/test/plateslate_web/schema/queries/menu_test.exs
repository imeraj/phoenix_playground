defmodule PlateslateWeb.Schema.Queries.MenuTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  @query """
  {
    menuItems(filter: {category: "Sandwiches"}) {
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
                 %{"name" => "Bánh mì"},
                 %{"name" => "Croque Monsieur"},
                 %{"name" => "Muffuletta"},
                 %{"name" => "Reuben"},
                 %{"name" => "Vada Pav"}
               ]
             }
           }
  end

  @query """
    query ($term: String) {
      menuItems(filter: {name: $term, category: "sandwiches"}) {
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
    menuItems(order: DESC, filter: {category: "Sandwiches"}) {
      name
    }
  }
  """

  test "menuItems field returns items descending using literals" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{
               "menuItems" => [%{"name" => "Vada Pav"} | _]
             }
           } = json_response(response, 200)
  end

  @query """
  {
    menuItems(filter: {category: "Sandwiches", tag: "Vegetarian"}) {
      name
    }
  }
  """

  test "menuItems field returns menuItems, filtering with a literal" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
           } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """

  @variables %{filter: %{"tag" => "Vegetarian", "category" => "Sandwiches"}}
  test "menuItems field returns menuItems, filtering with a variable" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
           } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
      addedOn
    }
  }
  """

  @variables %{filter: %{"addedBefore" => "2017-01-20", category: "Sides"}}
  test "menuItems filtered by custom scalar" do
    sides = Plateslate.Repo.get_by!(Plateslate.Menu.Category, name: "Sides")

    %Plateslate.Menu.Item{
      name: "Garlic Fries",
      added_on: ~D[2017-01-01],
      price: 2.50,
      category: sides
    }
    |> Plateslate.Repo.insert!()

    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "data" => %{
               "menuItems" => [%{"name" => "Garlic Fries", "addedOn" => "2017-01-01"}]
             }
           } == json_response(response, 200)
  end
end
