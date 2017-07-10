defmodule PhoenixApi.Repo.Migrations.CreatePhoenixApi.Sales.Order do
  use Ecto.Migration

  def change do
    create table(:sales_orders) do
      add :total, :decimal
      add :accounts_users_id, references(:accounts_users, on_delete: :nothing)

      timestamps()
    end

    create index(:sales_orders, [:accounts_users_id])
  end
end
