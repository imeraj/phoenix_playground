defmodule Plateslate.Repo.Migrations.CreateMenuTagTaggings do
  use Ecto.Migration

  def change do
    create table(:items_taggings, primary_key: false) do
      add :item_id, references(:items), null: false
      add :item_tag_id, references(:items_tags), null: false
    end
  end
end
