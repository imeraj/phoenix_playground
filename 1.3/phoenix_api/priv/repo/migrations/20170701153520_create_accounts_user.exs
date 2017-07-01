defmodule PhoenixApi.Repo.Migrations.CreatePhoenixApi.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :name, :string
      add :email, :string
      add :encrypted_password, :string

      timestamps()
    end

    create unique_index(:accounts_users, [:email])
  end
end
