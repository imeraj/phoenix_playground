defmodule MinitwitterWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Minitwitter.Accounts
  alias MinitwitterWeb.Router.Helpers, as: Routes

  @max_age 7 * 24 * 60 * 60

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)

      user = user_id && Accounts.get_user(user_id) ->
        put_current_user(conn, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  defp put_current_user(conn, user) do
    conn
    |> assign(:current_user, user)
  end

  def authenticate_user(conn, _opts) do
    cond do
      conn.assigns.current_user ->
        conn

      remember_token = conn.cookies["remember_token"] ->
        user_id = conn.cookies["user_id"]
        user = Accounts.get_user(user_id)

        if user && Accounts.authenticated?(user, remember_token) do
          login(conn, user)
        else
          halt_connection(conn)
        end

      true ->
        halt_connection(conn)
    end
  end

  defp halt_connection(conn) do
    conn
    |> put_flash(:error, "You must be logged in to access that page!")
    |> redirect(to: Routes.page_path(conn, :home))
    |> halt()
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    case Accounts.authenticate_by_email_and_pass(email, given_pass) do
      {:ok, user} -> {:ok, login(conn, user)}
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
      {:error, :not_found} -> {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    if conn.assigns.current_user do
      Accounts.forget_user(conn.assigns.current_user)

      conn
      |> delete_resp_cookie("user_id")
      |> delete_resp_cookie("remember_token")
      |> configure_session(drop: true)
    end
  end

  def remember(conn, user, token) do
    conn =
      conn
      |> put_resp_cookie("user_id", Integer.to_string(user.id), max_age: @max_age)
      |> put_resp_cookie("remember_token", token, max_age: @max_age)

    conn
  end
end
