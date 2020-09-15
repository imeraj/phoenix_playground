defmodule Plateslate.Ordering do
  @moduledoc """
  The Ordering context.
  """

  import Ecto.Query, warn: false
  alias Plateslate.Repo

  alias Plateslate.Ordering.Order

  def create_order(attrs \\ %{}) do
    attrs = Map.update(attrs, :items, [], &build_items/1)

    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  defp build_items(items) do
    for item <- items do
      menu_item = Plateslate.Menu.get_item!(item.menu_item_id)
      %{name: menu_item.name, quantity: item.quantity, price: menu_item.price}
    end
  end

  def get_order!(id), do: Repo.get!(Order, id)

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def orders_by_item_name(%{since: since}, names) do
    query =
      from [i, o] in name_query(since, names),
        order_by: [desc: o.ordered_at],
        select: %{name: i.name, order: o}

    query
    |> Repo.all()
    |> Enum.group_by(& &1.name, & &1.order)
  end

  defp name_query(since, names) do
    from i in "order_items",
      join: o in Order,
      on: o.id == i.order_id,
      where: o.ordered_at >= type(^since, :date),
      where: i.name in ^names
  end

  def orders_stats_by_name(%{since: since}, names) do
    Map.new(
      Repo.all(
        from i in name_query(since, names),
          group_by: i.name,
          select:
            {i.name,
             %{
               quantity: sum(i.quantity),
               gross: sum(fragment("? * ?", i.price, i.quantity))
             }}
      )
    )
  end
end
