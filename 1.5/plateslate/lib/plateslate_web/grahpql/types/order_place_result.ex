defmodule PlateslateWeb.Graphql.Types.OrderPlaceResult do
  use Absinthe.Schema.Notation
  alias(Graphql.Resolvers.OrderPlaceResult)

  union :order_place_result do
    types([:order, :errors])

    resolve_type(&OrderPlaceResult.order_place_result/2)
  end
end
