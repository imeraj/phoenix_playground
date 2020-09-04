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
end
