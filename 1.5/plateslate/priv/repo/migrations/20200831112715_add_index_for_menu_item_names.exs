defmodule Plateslate.Repo.Migrations.AddIndexForMenuItemNames do
  use Ecto.Migration

  def change do
    create unique_index(:items, [:name])
  end
end
