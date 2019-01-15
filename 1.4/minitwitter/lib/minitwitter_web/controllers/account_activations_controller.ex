defmodule MinitwitterWeb.AccountActivationsController do
  use MinitwitterWeb, :controller

  alias Minitwitter.Accounts
  alias MinitwitterWeb.Auth

  def edit(conn, %{"id" => id, "email" => email}) do
    with user <- Accounts.get_user_by(%{email: email}),
         false <- user.activated,
         true <- Accounts.authenticated?(user, :activation, id) do
      Accounts.update_user(user, %{
        activated: true,
        activated_at: DateTime.truncate(DateTime.utc_now(), :second)
      })

      conn
      |> Auth.login(user)
      |> put_flash(:info, "Account activated!")
      |> redirect(to: Routes.user_path(conn, :show, user))
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid activation link!")
        |> redirect(to: Routes.page_path(conn, :home))
    end
  end
end
