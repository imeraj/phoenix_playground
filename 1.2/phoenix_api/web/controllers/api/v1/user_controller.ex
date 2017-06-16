defmodule PhoenixApi.Api.V1.UserController do
  use PhoenixApi.Web, :controller
  import PhoenixApi.AuthHelper
  alias PhoenixApi.Repo
  alias PhoenixApi.User

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__]  when action in [:index, :show, :delete, :update]
  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, %{"page" => page, "per_page" => per_page}) do
    page = User
           |> Repo.paginate(page: page, page_size: per_page)
    conn
    |> render("index.json", users: page.entries)
  end

  def show(conn,_params) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found", error: :not_found})
      user ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user)
      end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found", error: :not_found})
      user ->
        Repo.delete!(user)
        remove_token(conn)
        send_resp(conn, :no_content, "")
    end
  end

  def update(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.registration_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Authentication required", error: :unauthorized})
  end
end
