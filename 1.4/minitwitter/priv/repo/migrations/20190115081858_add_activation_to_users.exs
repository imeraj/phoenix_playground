defmodule Minitwitter.Repo.Migrations.AddActivationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :activation_hash, :string
      add :activated, :boolean, default: false
      add :activated_at, :utc_datetime
    end
  end
end
