defmodule Minitwitter.Repo.Migrations.AddPictureToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :picture, :string
    end
  end
end
