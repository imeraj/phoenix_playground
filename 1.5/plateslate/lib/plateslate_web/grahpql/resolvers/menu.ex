defmodule Graphql.Resolvers.Menu do
  alias Plateslate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def create_item(_, %{input: params}, _) do
    case Menu.create_item(params) do
      {:error, _} ->
        {:error, "Could not create menu item"}

      {:ok, _} = success ->
        success
    end
  end
end
