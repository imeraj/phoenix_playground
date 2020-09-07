defmodule PlateslateWeb.Schema.Queries.SearchTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  @query """
  query Search($term: String!) {
    search(matching: $term) {
      ... on MenuItem { name }
      ... on Category { name }
      __typename
    }
  }
  """

  @variables %{term: "e"}
  test "search returns a list of menu items and categories" do
    user = Factory.create_user("employee")
    conn = build_conn() |> auth_user(user)

    response = get(conn, "/api", query: @query, variables: @variables)

    assert %{"data" => %{"search" => results}} = json_response(response, 200)
    assert length(results) > 0
    assert Enum.find(results, &(&1["__typename"] == "Category"))
    assert Enum.find(results, &(&1["__typename"] == "MenuItem"))
  end

  defp auth_user(conn, user) do
    token = PlateslateWeb.Graphql.Authentication.sign(%{role: user.role, id: user.id})
    put_req_header(conn, "authorization", "Bearer #{token}")
  end
end
