defmodule PhoenixApi.Web.UserController do
  use PhoenixApi.Web, :controller

  alias PhoenixApi.Accounts
  alias PhoenixApi.Accounts.User

  action_fallback PhoenixApi.Web.FallbackController
  plug Guardian.Plug.EnsureAuthenticated, [handler: PhoenixApi.Web.FallbackController]  when action in [:index, :show, :delete, :update]
	plug :scrub_params, "user" when action in [:create, :update]

  def index(%{assigns: %{version: :v1}} = conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.v1.json", users: users)
  end

  def create(%{assigns: %{version: :v1}} = conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.v1.json", user: user)
    end
  end

  def show(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.v1.json", user: user)
  end

  def update(%{assigns: %{version: :v1}} = conn, %{"id" => id, "user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.v1.json", user: user)
    end
  end

  def delete(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
