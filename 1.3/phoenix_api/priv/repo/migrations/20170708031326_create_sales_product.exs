defmodule PhoenixApi.Repo.Migrations.CreatePhoenixApi.Sales.Product do
  use Ecto.Migration

  def change do
    create table(:sales_products) do
      add :title, :string
      add :price, :decimal
      add :published, :boolean, default: false, null: false
      add :accounts_users_id, references(:accounts_users, on_delete: :delete_all)

      timestamps()
    end

    create index(:sales_products, [:accounts_users_id])
  end
end
