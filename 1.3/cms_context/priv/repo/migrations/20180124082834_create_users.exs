defmodule CmsContext.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
