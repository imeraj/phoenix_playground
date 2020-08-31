defmodule PlateslateWeb.Schema do
  use Absinthe.Schema

  import_types(PlateslateWeb.Graphql.Types.Menu)
  import_types(PlateslateWeb.Graphql.Types.Category)
  import_types(PlateslateWeb.Graphql.Types.SearchResult)

  import_types(PlateslateWeb.Graphql.InputTypes.MenuItemInput)

  query do
    import_fields(:menu_queries)
    import_fields(:search_queries)
  end

  mutation do
    import_fields(:menu_item_create)
  end

  object :menu_queries do
    field :menu_items, list_of(:menu_item), description: "The list of available menu items" do
      arg(:filter, non_null(:menu_item_filter))
      arg(:order, :sort_order, default_value: :asc)
      resolve(&Graphql.Resolvers.Menu.menu_items/3)
    end
  end

  object :search_queries do
    field :search, list_of(:search_result) do
      arg(:matching, non_null(:string))
      resolve(&Graphql.Resolvers.SearchResult.search/3)
    end
  end

  object :menu_item_create do
    field :menu_item_create, :menu_item do
      arg(:input, non_null(:menu_item_input))
      resolve(&Graphql.Resolvers.Menu.create_item/3)
    end
  end
end
