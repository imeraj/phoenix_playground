defmodule PlateslateWeb.Graphql.Types.Category do
  use Absinthe.Schema.Notation

  object :category do
    field :id, :id
    field :name, :string
    field :description, :string

    field :items, list_of(:menu_item) do
      resolve(&Graphql.Resolvers.Menu.items_for_category/3)
    end
  end
end
