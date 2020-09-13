defmodule PlateslateWeb.SessionController do
  use PlateslateWeb, :controller
  use Absinthe.Phoenix.Controller, schema: PlateslateWeb.Schema, action: [mode: :internal]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  @graphql """
  mutation ($email: String!, $password: String!) {
    login(input: {
      email: $email,
      password: $password
    })
  }
  """
  def create(conn, %{data: %{login: result}}) do
    IO.inspect(result)

    case result do
      %{user: employee} ->
        conn
        |> put_session(:employee_id, employee.id)
        |> put_flash(:info, "Login successful")
        |> redirect(to: "/admin/items")

      _ ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> clear_session
    |> redirect(to: "/admin/session/new")
  end
end
