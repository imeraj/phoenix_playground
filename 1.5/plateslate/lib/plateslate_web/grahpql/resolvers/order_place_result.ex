defmodule Graphql.Resolvers.OrderPlaceResult do
  def order_place_result(%Plateslate.Ordering.Order{}, _), do: :order
  def order_place_result(%{errors: _}, _), do: :errors
  def order_place_result(_, _), do: nil
end
