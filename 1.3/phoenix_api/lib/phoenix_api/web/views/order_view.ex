defmodule PhoenixApi.Web.OrderView do
  use PhoenixApi.Web, :view
  alias PhoenixApi.Web.OrderView

  def render("index.v1.json", %{orders: orders}) do
    %{data: render_many(orders, OrderView, "order.v1.json")}
  end

  def render("show.v1.json", %{order: order}) do
    %{
      data: %{
        user_id: order.accounts_users_id,
        order_id: order.id,
        total: order.total,
        products:
          Enum.map_every(order.sales_products, 1, fn prod ->
            %{id: prod.id, price: prod.price, title: prod.title}
          end)
      }
    }
  end

  def render("order.v1.json", %{order: order}) do
    %{id: order.id, total: order.total}
  end

  # ETag caching: Consumer must send If-None-Match (Etag)
  # or If-Modified-Since (Last Modified)
  def stale_checks("show.v1.json", %{order: order}) do
    [etag: PhoenixETag.schema_etag(order), last_modified: PhoenixETag.schema_last_modified(order)]
  end
end
