defmodule PhoenixApi.Repo.Migrations.CreateOrderProduct do
  use Ecto.Migration

  def change do
    create table(:order_products) do
      add :order_id, references(:orders, on_delete: :nilify_all)
      add :product_id, references(:products, on_delete: :nilify_all)

      timestamps()
    end
      create index(:order_products, [:order_id, :product_id])

  end
end
