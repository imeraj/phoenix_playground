defmodule Minitwitter.Repo.Migrations.AddResetToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :reset_hash, :string
      add :reset_sent_at, :utc_datetime
    end
  end
end
