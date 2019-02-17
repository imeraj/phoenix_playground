defmodule Plateslate.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :description, :string
    field :name, :string
    field :price, :decimal

    belongs_to :category, Plateslate.Menu.Category

    many_to_many :tags, Plateslate.Menu.ItemTag, join_through: "items_taggings"

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price])
    |> validate_required([:name, :price])
    |> foreign_key_constraint(:category)
  end
end
