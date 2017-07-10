defmodule PhoenixApi.Repo.Migrations.CreateSalesOrdersProducts do
  use Ecto.Migration

  def change do
    create table(:sales_orders_products, primary_key: false) do
        add :order_id, references(:sales_orders)
        add :product_id, references(:sales_products)
    end
  end
end
