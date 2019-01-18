defmodule MinitwitterWeb.PasswordResetController do
  use MinitwitterWeb, :controller

  alias Minitwitter.Accounts
  alias MinitwitterWeb.Email
  alias Minitwitter.Mailer
  alias MinitwitterWeb.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"password_reset" => %{"email" => email}}) do
    user = Accounts.get_user_by(%{email: email})

    if user do
      reset_token = Accounts.reset_hash(user)

      Email.password_reset_html_email(conn, user, reset_token)
      |> Mailer.deliver_later()

      conn
      |> put_flash(:info, "Email sent with password reset instructions.")
      |> redirect(to: Routes.page_path(conn, :home))
    else
      conn
      |> put_flash(:info, "Email address not found!")
      |> render("new.html")
    end
  end

  def edit(conn, %{"email" => email, "id" => id}) do
    if Accounts.valid_user?(email, id) do
      user = Accounts.get_user_by(%{email: email})
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Password reset link is invalid!")
      |> redirect(to: Routes.page_path(conn, :home))
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user(id)

    case Accounts.reset_user_pass(user, user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "Password has been reset.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
