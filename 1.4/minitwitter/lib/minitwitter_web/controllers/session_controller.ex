defmodule MinitwitterWeb.SessionController do
  use MinitwitterWeb, :controller

  alias Minitwitter.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case MinitwitterWeb.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        user = Accounts.get_user_by(%{email: email})
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination!")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> MinitwitterWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :home))
  end
end
