defmodule BlogAppGql.Repo.Migrations.AddTokenToAccountsUsers do
  use Ecto.Migration

  def change do
	  alter table(:accounts_users) do
		  add :token, :text
	  end
  end
end
