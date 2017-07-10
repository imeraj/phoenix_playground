defmodule PhoenixApi.Sales.OrderProduct do
  use Ecto.Schema

  schema "sales_orders_products" do
    belongs_to :sales_orders, PhoenixApi.Sales.Order
    belongs_to :sales_products, PhoenixApi.Sales.Product

    timestamps()
  end
end