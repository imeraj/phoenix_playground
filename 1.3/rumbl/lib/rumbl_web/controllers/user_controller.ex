defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  import Rumbl.Auth, only: [load_current_user: 2]

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  plug(:load_current_user when action in [:show, :index])

  def index(conn, _params) do
    users = Accounts.list_users()

    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> render("index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end
end
