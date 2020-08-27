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
  alias Plateslate.{Repo, Menu.Item}

  def list_items(filters) do
    filters
    |> Enum.reduce(Item, fn
      {_, nil}, query ->
        query

      {:order, order}, query ->
        from q in query, order_by: {^order, :name}

      {:matching, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")
    end)
    |> Repo.all()
  end
end
