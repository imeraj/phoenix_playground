defmodule Graphql.Resolvers.Menu do
  alias Plateslate.Menu
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def create_item(_, %{input: params}, _) do
    with {:ok, item} <- Menu.create_item(params) do
      {:ok, item}
    end
  end

  def category_for_item(menu_item, _, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Menu, :category, menu_item)
    |> on_load(fn loader ->
      category = Dataloader.get(loader, Menu, :category, menu_item)
      {:ok, category}
    end)
  end

  def items_for_category(category, _, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Menu, :items, category)
    |> on_load(fn loader ->
      items = Dataloader.get(loader, Menu, :items, category)
      {:ok, items}
    end)
  end
end
