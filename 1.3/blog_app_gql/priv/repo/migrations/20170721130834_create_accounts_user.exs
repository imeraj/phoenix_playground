defmodule BlogAppGql.Repo.Migrations.CreateBlogAppGql.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :name, :string
      add :email, :string

      timestamps()
    end

		create unique_index(:accounts_users, [:email])
  end
end
