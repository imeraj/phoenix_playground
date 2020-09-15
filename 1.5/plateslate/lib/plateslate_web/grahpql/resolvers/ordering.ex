defmodule Graphql.Resolvers.Ordering do
  alias Plateslate.Ordering
  import Absinthe.Resolution.Helpers

  def order_place(_, %{input: order_place_input}, %{context: context}) do
    order_place_input =
      case context[:current_user] do
        %{role: "customer", id: id} ->
          Map.put(order_place_input, :customer_id, id)

        _ ->
          order_place_input
      end

    with {:ok, order} <- Ordering.create_order(order_place_input) do
      Absinthe.Subscription.publish(PlateslateWeb.Endpoint, order,
        new_order: [order.customer_id, "*"]
      )

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

  def order_history(item, args, _) do
    one_month_ago = Date.utc_today() |> Date.add(-30)

    args =
      Map.update(args, :since, one_month_ago, fn date ->
        date || one_month_ago
      end)

    {:ok, %{item: item, args: args}}
  end

  def orders(%{item: item, args: args}, _, _) do
    batch({Ordering, :orders_by_item_name, args}, item.name, fn orders ->
      {:ok, Map.get(orders, item.name, [])}
    end)
  end

  def stat(stat) do
    fn %{item: item, args: args}, _, _ ->
      batch({Ordering, :orders_stats_by_name, args}, item.name, fn results ->
        {:ok, results[item.name][stat] || 0}
      end)
    end
  end
end
