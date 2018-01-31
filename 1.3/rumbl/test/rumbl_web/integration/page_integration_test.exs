defmodule RumblWeb.PageIntegrationTest do
  use RumblWeb.IntegrationCase, async: true

  describe "Page flow" do
    test "Register a new user", %{conn: conn} do
      get(conn, page_path(conn, :index))
      |> follow_link("Register")
      |> follow_form(%{
        user: %{
          name: "Test User",
          username: "tester",
          password: "password"
        }
      })
      |> assert_response(
        status: 200,
        path: user_path(conn, :index),
        html: "Listing Users"
      )
    end

    test "Login fails for non-existing user", %{conn: conn} do
      get(conn, page_path(conn, :index))
      |> follow_link("Log In")
      |> follow_form(%{
        session: %{
          username: "tester",
          password: "password"
        }
      })
      |> assert_response(
        status: 200,
        path: session_path(conn, :create),
        html: "Login"
      )
    end

    test "Log in existing user", %{conn: conn} do
      user = insert_user()

      get(conn, page_path(conn, :index))
      |> follow_link("Log In")
      |> follow_form(%{
        session: %{
          username: user.username,
          password: user.password
        }
      })
      |> assert_response(
        status: 200,
        path: user_path(conn, :index),
        html: "Listing Users"
      )
    end
  end
end
