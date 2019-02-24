defmodule Plateslate.Menu do
  import Ecto.Query, warn: false
  alias Plateslate.Repo

  alias Plateslate.Menu.Item

  def list_items(filters) do
    filters
    |> Enum.reduce(Item, fn
      {:order, order}, query ->
        from q in query, order_by: {^order, :name}

      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> Repo.all()
  end

  defp filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:name, name}, query ->
        from q in query, where: like(q.name, ^"%#{name}%")

      {:priced_above, price}, query ->
        from q in query, where: q.price >= ^price

      {:priced_below, price}, query ->
        from q in query, where: q.price <= ^price

      {:added_after, date}, query ->
        from q in query, where: q.added_on >= ^date

      {:added_before, date}, query ->
        from q in query, where: q.added_on <= ^date

      {:category, category_name}, query ->
        from q in query,
          join: c in assoc(q, :category),
          where: like(c.name, ^"%#{category_name}%")

      {:tag, tag_name}, query ->
        from q in query,
          join: t in assoc(q, :tags),
          where: like(t.name, ^"%#{tag_name}%")
    end)
  end
end
