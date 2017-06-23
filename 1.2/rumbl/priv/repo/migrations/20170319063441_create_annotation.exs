defmodule Rumbl.Repo.Migrations.CreateAnnotation do
  use Ecto.Migration

  def change do
    create table(:annotations) do
      add :body, :text
      add :at, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :video_id, references(:videos, on_delete: :delete_all)

      timestamps()
    end

    create index(:annotations, [:user_id, :video_id])
  end

end

