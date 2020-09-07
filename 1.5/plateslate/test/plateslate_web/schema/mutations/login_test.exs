defmodule PlateslateWeb.Schema.Mutation.LoginEmployeeTest do
  use PlateslateWeb.ConnCase, async: true

  @query """
  mutation login($email: String!) {
  	login(input: {
      	email: $email,
      	password: "super-secret"
    }) {
      token
      user {
        name
      }
    }
  }
  """

  test "creating an employee session" do
    user = Factory.create_user("employee")

    response =
      post(build_conn(), "/api", %{
        query: @query,
        variables: %{email: user.email}
      })

    assert %{
             "data" => %{
               "login" => %{
                 "token" => token,
                 "user" => user_data
               }
             }
           } = json_response(response, 200)

    assert %{"name" => user.name} == user_data

    assert {:ok, %{role: "employee", id: user.id}} ==
             PlateslateWeb.Authentication.verify(token)
  end
end
