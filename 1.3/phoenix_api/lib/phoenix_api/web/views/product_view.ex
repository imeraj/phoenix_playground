defmodule PhoenixApi.Web.ProductView do
  use PhoenixApi.Web, :view
  alias PhoenixApi.Web.ProductView

  def render("index.v1.json", %{products: products,
                                      page_number: page_number,
                                      page_size: page_size,
                                      total_pages: total_pages,
                                      total_entries: total_entries}) do

    %{data: render_many(products, ProductView, "product.v1.json"),
        page_info:
          %{page_number: page_number,
            page_size: page_size,
            total_pages: total_pages,
            total_entries: total_entries}
     }

  end

  def render("show.v1.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.v1.json")}
  end

  def render("product.v1.json", %{product: product}) do
    %{id: product.id,
      title: product.title,
      price: product.price
      }
  end
end
