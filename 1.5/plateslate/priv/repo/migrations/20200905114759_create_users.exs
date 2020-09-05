defmodule Plateslate.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :role, :string

      timestamps()
    end

    create unique_index(:users, [:email, :role])
  end
end
