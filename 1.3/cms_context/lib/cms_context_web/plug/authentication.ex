defmodule Authentication do
  import Plug.Conn
  import Phoenix.Controller

  def authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Login required")
        |> redirect(to: "/")
        |> halt()

      user_id ->
        assign(conn, :current_user, CmsContext.Accounts.get_user!(user_id))
    end
  end
end
