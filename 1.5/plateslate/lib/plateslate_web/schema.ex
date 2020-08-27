defmodule PlateslateWeb.Schema do
  use Absinthe.Schema
  alias Plateslate.{Repo, Menu}
  import Ecto.Query

  query do
    field :menu_items, list_of(:menu_item), description: "The list of available menu items" do
      arg(:matching, :string)
      arg(:order, :sort_order)
      resolve(&Graphql.Resolvers.Menu.menu_items/3)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end
