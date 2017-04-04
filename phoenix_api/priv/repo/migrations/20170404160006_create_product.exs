defmodule PhoenixApi.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :price, :decimal
      add :published, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:products, [:user_id])

  end
end
