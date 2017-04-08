defmodule PhoenixApi.Api.V1.OrderView do
  use PhoenixApi.Web, :view

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, PhoenixApi.Api.V1.OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, PhoenixApi.Api.V1.OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{id: order.id}
  end
end
