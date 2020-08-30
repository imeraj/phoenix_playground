# ---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
# ---
defmodule Plateslate.Menu do
  @moduledoc """
  The Menu context.
  """

  import Ecto.Query, warn: false
  alias Plateslate.{Repo, Menu.Item, Menu.Category}

  def list_items(args) do
    args
    |> Enum.reduce(Item, fn
      {:order, order}, query ->
        from q in query, order_by: {^order, :name}

      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> Repo.all()
  end

  defp filter_with(_query, filter) do
    filter
    |> Enum.reduce(Item, fn
      {:name, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")

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
          where: ilike(c.name, ^"%#{category_name}%")

      {:tag, tag_name}, query ->
        from q in query,
          join: t in assoc(q, :tags),
          where: ilike(t.name, ^"%#{tag_name}%")
    end)
  end

  @search [Item, Category]
  def search(term) do
    pattern = "%#{term}%"
    Enum.flat_map(@search, &search_ecto(&1, pattern))
  end

  defp search_ecto(ecto_schema, pattern) do
    Repo.all(
      from q in ecto_schema,
        where: ilike(q.name, ^pattern) or ilike(q.description, ^pattern)
    )
  end
end
