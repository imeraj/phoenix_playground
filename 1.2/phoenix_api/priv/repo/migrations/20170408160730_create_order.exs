defmodule PhoenixApi.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total, :decimal
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end
    create index(:orders, [:user_id])

  end
end
