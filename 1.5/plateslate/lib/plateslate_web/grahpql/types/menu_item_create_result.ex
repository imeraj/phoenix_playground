defmodule PlateslateWeb.Graphql.Types.SearchResult do
  use Absinthe.Schema.Notation



  union :search_result do
    types([:menu_item, :category])

    resolve_type(fn
      %Plateslate.Menu.Item{}, _ ->
        :menu_item

      %Plateslate.Menu.Category{}, _ ->
        :category

      _, _ ->
        nil
    end)
  end
end
