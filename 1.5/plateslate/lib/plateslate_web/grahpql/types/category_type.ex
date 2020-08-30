defmodule PlateslateWeb.Graphql.Types.CategoryType do
  use Absinthe.Schema.Notation

  object :category do
    field :name, :string
    field :description, :string

    field :items, list_of(:menu_item) do
      resolve(fn category, _, _ ->
        # N + 1 Query
        query = Ecto.assoc(category, :items)
        {:ok, Plateslate.Repo.all(query)}
      end)
    end
  end
end
