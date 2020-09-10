defmodule PlateslateWeb.Graphql.Types.Category do
  use Absinthe.Schema.Notation
  alias Plateslate.Menu
  import Absinthe.Resolution.Helpers

  object :category do
    field :id, :id
    field :name, :string
    field :description, :string

    field :items, list_of(:menu_item) do
      resolve dataloader(Menu, :items)
    end
  end
end
