defmodule PlateslateWeb.Graphql.Types.MenuItemCreateResult do
  use Absinthe.Schema.Notation
  alias(Graphql.Resolvers.MenuItemCreateResult)

  union :menu_item_create_result do
    types([:menu_item, :errors])

    resolve_type(&MenuItemCreateResult.menu_item_create_result/2)
  end
end
