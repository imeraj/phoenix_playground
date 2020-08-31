# ---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
# ---
defmodule Plateslate.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plateslate.Menu.{Item, Category}

  schema "items" do
    field :added_on, :date
    field :description, :string
    field :name, :string
    field :price, :decimal

    belongs_to :category, Plateslate.Menu.Category

    many_to_many :tags, Plateslate.Menu.ItemTag, join_through: "items_taggings"

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :category_id])
    |> validate_required([:name, :price, :category_id])
    |> foreign_key_constraint(:category)
  end
end
