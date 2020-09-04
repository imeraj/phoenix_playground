defmodule Graphql.Resolvers.Ordering do
  alias Plateslate.Ordering

  def order_place(_, %{input: order_place_input}, _) do
    with {:ok, order} <- Ordering.create_order(order_place_input) do
      Absinthe.Subscription.publish(PlateslateWeb.Endpoint, order, new_order: "*")
      {:ok, order}
    end
  end

  def ready_order(_, %{id: id}, _) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "ready"}) do
      {:ok, order}
    end
  end

  def complete_order(_, %{id: id}, _) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "complete"}) do
      {:ok, order}
    end
  end
end
