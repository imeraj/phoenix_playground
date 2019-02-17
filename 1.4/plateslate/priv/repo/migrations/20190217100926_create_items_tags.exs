defmodule Plateslate.Repo.Migrations.CreateItemsTags do
  use Ecto.Migration

  def change do
    create table(:items_tags) do
      add :name, :string, null: false
      add :description, :string

      timestamps()
    end
  end
end
