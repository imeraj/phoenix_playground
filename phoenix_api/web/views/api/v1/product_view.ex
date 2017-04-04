defmodule PhoenixApi.Api.V1.ProductView do
  use PhoenixApi.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, PhoenixApi.ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, PhoenixApi.ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      title: product.title,
      price: product.price,
      published: product.published,
      user_id: product.user_id}
  end
end
