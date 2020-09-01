defmodule PlateslateWeb.Graphql.Types.OrderPlaceResult do
  use Absinthe.Schema.Notation
  alias(Graphql.Resolvers.OrderPlaceResult)

  import_types(PlateslateWeb.Graphql.Types.Order)

  union :order_place_result do
    types([:order, :errors])

    resolve_type(&OrderPlaceResult.order_place_result/2)
  end
end
