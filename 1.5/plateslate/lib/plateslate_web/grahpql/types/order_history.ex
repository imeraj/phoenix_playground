defmodule PlateslateWeb.Graphql.Types.OrderHistory do
  use Absinthe.Schema.Notation

  object :order_history do
    field :orders, list_of(:order) do
      resolve(&Graphql.Resolvers.Ordering.orders/3)
    end

    field :quantity, non_null(:integer) do
      resolve(Graphql.Resolvers.Ordering.stat(:quantity))
    end

    field :gross, non_null(:float) do
      resolve(Graphql.Resolvers.Ordering.stat(:gross))
    end
  end
end
