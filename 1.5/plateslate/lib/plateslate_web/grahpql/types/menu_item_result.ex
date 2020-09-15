defmodule PlateslateWeb.Graphql.Types.MenuItemResult do
  use Absinthe.Schema.Notation

  alias PlateSlateWeb.Graphql.Middleware.Authorize

  object :menu_item_result do
    field :menu_item, :menu_item do
      resolve(fn menu_item, _, _ ->
        {:ok, menu_item}
      end)
    end

    field :order_history, :order_history do
      arg(:since, :date)
      middleware(Authorize, "employee")
      resolve(&Graphql.Resolvers.Ordering.order_history/3)
    end
  end
end
