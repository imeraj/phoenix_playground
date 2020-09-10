defmodule Graphql.Resolvers.Menu do
  alias Plateslate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def create_item(_, %{input: params}, _) do
    with {:ok, item} <- Menu.create_item(params) do
      {:ok, item}
    end
  end

  def category_for_item(menu_item, _, _) do
    query = Ecto.assoc(menu_item, :category)
    {:ok, Plateslate.Repo.one(query)}
  end

  def item_for_category(category, _, _) do
    query = Ecto.assoc(category, :items)
    {:ok, Plateslate.Repo.all(query)}
  end
end
