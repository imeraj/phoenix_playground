defmodule FrescoWeb.Subdomain.ProductsController do
  use FrescoWeb, :controller

  alias Fresco.Products
  alias Fresco.Accounts

  def index(conn, _params) do
    tenant = conn.private[:subdomain]
    all_products = Products.list_products(tenant)
    brand_color = Accounts.get_account!(tenant).brand_colour

    render(
      conn,
      "index.html",
      %{
        subdomain: tenant,
        products: all_products,
        style: "background-color: #{brand_color};"
      }
    )
  end
end