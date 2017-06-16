defmodule PhoenixApi.Api.V1.OrderView do
  use PhoenixApi.Web, :view

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, PhoenixApi.Api.V1.OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, PhoenixApi.Api.V1.OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    product_ids = Enum.map_every(order.order_products, 1, fn(op) -> op.product_id end)
    %{id: order.id, total: order.total, product_ids: product_ids}
  end

  # ETag caching: Consumer must send If-None-Match (Etag)
  # or If-Modified-Since (Last Modified)
  def stale_checks("show." <> _format, %{order: order}) do
   [etag: PhoenixETag.schema_etag(order),
   last_modified: PhoenixETag.schema_last_modified(order)]
  end
end
