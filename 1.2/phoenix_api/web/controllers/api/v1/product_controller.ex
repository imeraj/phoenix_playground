defmodule PhoenixApi.Api.V1.ProductController do
  use PhoenixApi.Web, :controller
  alias PhoenixApi.Product

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__]  when action in [:index, :create, :show, :delete, :update]
  plug :scrub_params, "product" when action in [:create, :update]

  def index(conn, %{"page" => page, "per_page" => per_page}) do
    page = Product
           |> where([p], p.published == true)
           |> Repo.paginate(page: page, page_size: per_page)
    conn
    |> render("index.json", products: page.entries)
  end

  def create(conn, %{"product" => product_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset =
        user
        |> build_assoc(:products)
        |> Product.changeset(product_params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", product_path(conn, :show, product))
        |> render("show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    user = Guardian.Plug.current_resource(conn)
    product = Repo.get!(user_products(user), id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
        {:ok, product} ->
            render(conn, "show.json", product: product)
        {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    product = Repo.get!(user_products(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    send_resp(conn, :no_content, "")
  end

  defp user_products(user) do
      assoc(user, :products)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Authentication required", error: :unauthorized})
  end
end
