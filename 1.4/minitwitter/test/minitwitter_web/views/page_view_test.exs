defmodule MinitwitterWeb.PageViewTest do
  use MinitwitterWeb.ConnCase, async: true
  import Phoenix.View

  setup %{conn: conn} do
      conn =
          conn
          |> bypass_through(MinitwitterWeb.Router, :browser)
          |> get("/")
      {:ok, %{conn: conn}}
  end

  test "render home.html", %{conn: conn} do
      content = render_to_string(MinitwitterWeb.PageView, "home.html", conn: conn)
      assert String.contains?(content, "Sign up now!")
  end

  test "render contact.html", %{conn: conn} do
      content = render_to_string(MinitwitterWeb.PageView, "contact.html", conn: conn)
      assert String.contains?(content, "Mohammad Merajul Islam Molla")
  end

  test "check app layout", %{conn: conn} do
      content = render_to_string(MinitwitterWeb.PageView, "home.html", conn: conn, current_user: nil, layout: {MinitwitterWeb.LayoutView, "app.html"})
      assert String.contains?(content, "Home")
      assert String.contains?(content, "Contact")
      assert String.contains?(content, "Log in")
  end
end
