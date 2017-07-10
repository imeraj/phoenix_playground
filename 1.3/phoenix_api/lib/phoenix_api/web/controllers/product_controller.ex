defmodule PhoenixApi.Web.ProductController do
  use PhoenixApi.Web, :controller

  alias PhoenixApi.Sales
  alias PhoenixApi.Sales.Product

  action_fallback PhoenixApi.Web.FallbackController
  plug Guardian.Plug.EnsureAuthenticated, [handler: PhoenixApi.Web.FallbackController]
    when action in [:index, :create, :delete, :update]
  plug :scrub_params, "product" when action in [:create, :update]

  def index(%{assigns: %{version: :v1}} = conn, %{"page" => page, "per_page" => page_size}) do
		page = Sales.get_product_page(page, page_size)
    render(conn, "index.v1.json",
                      products: page.entries,
                      page_number: page.page_number,
                      page_size: page.page_size,
                      total_pages: page.total_pages,
                      total_entries: page.total_entries)
  end

  def create(%{assigns: %{version: :v1}} = conn, %{"product" => product_params}) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, %Product{} = product} <- Sales.create_product(Map.put_new(product_params, "accounts_users_id", user.id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", product_path(conn, :show, product))
      |> render("show.v1.json", product: product)
    end
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

