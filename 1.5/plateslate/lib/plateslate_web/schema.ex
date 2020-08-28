defmodule PlateslateWeb.Schema do
  use Absinthe.Schema
  import Ecto.Query

  import_types(PlateslateWeb.Graphql.Types.MenuTypes)

  query do
    import_fields(:menu_queries)
  end

  object :menu_queries do
    field :menu_items, list_of(:menu_item), description: "The list of available menu items" do
      arg(:filter, non_null(:menu_item_filter))
      arg(:order, :sort_order, default_value: :asc)
      resolve(&Graphql.Resolvers.Menu.menu_items/3)
    end
  end
end
