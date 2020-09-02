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
end
