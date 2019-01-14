defmodule MinitwitterWeb.SessionController do
  use MinitwitterWeb, :controller

  alias Minitwitter.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{
        "session" => %{"email" => email, "password" => password, "remember_me" => remember_me}
      }) do
    case MinitwitterWeb.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        user = Accounts.get_user_by(%{email: email})

        conn =
          if String.to_atom(remember_me) do
            token = Accounts.remember_user(user)
            MinitwitterWeb.Auth.remember(conn, user, token)
          else
            Accounts.forget_user(user)
            conn
          end

        conn
        |> put_flash(:info, "Welcome back!")
        |> MinitwitterWeb.Auth.redirect_back_or(Routes.user_path(conn, :show, user))

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
