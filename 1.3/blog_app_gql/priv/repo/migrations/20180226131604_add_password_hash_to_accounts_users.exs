defmodule BlogAppGql.Repo.Migrations.AddPasswordHashToAccountsUser do
  use Ecto.Migration

  def change do
    alter table(:accounts_users) do
      add :password_hash, :string
    end
  end
end
