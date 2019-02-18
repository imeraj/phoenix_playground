defmodule Plateslate.Menu do
  import Ecto.Query, warn: false
  alias Plateslate.Repo

  alias Plateslate.Menu.Item

  def list_items(filters) do
    filters
    |> Enum.reduce(Item, fn
      {_, nil}, query ->
        query

      {:order, order}, query ->
        from q in query, order_by: {^order, :name}

      {:matching, name}, query ->
        from q in query, where: like(q.name, ^"%#{name}%")
    end)
    |> Repo.all()
  end
end
