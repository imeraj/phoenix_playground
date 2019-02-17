defmodule Plateslate.Menu.ItemTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items_tags" do
    field :description
    field :name, :string, null: false

    many_to_many :items, Plateslate.Menu.Item, join_through: "items_taggings"

    timestamps()
  end

  @doc false
  def changeset(item_tag, attrs) do
    item_tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
