defmodule PhoenixApi.Web.ProductController do
  use PhoenixApi.Web, :controller

  alias PhoenixApi.Sales
  alias PhoenixApi.Sales.Product

  action_fallback PhoenixApi.Web.FallbackController
  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__]
    when action in [:index, :create, :show, :delete, :update]
  plug :scrub_params, "product" when action in [:create, :update]

  def index(%{assigns: %{version: :v1}} = conn, _params) do
    products = Sales.list_products()
    render(conn, "index.v1.json", products: products)
  end

  def create(%{assigns: %{version: :v1}} = conn, %{"product" => product_params}) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, %Product{} = product} <- Sales.create_product(product_params, user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", product_path(conn, :show, product))
      |> render("show.v1.json", product: product)
    end
  end

  def show(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    product = Sales.get_product!(id)
    render(conn, "show.v1.json", product: product)
  end

  def update(%{assigns: %{version: :v1}} = conn, %{"id" => id, "product" => product_params}) do
    user = Guardian.Plug.current_resource(conn)
    product = Sales.get_product!(id)

    with {:ok, %Product{} = product} <- Sales.update_product(product, product_params, user) do
      render(conn, "show.v1.json", product: product)
    end
  end

  def delete(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    product = Sales.get_product!(id)

    with {:ok, %Product{}} <- Sales.delete_product(product, user) do
      send_resp(conn, :no_content, "")
    end
  end
end

