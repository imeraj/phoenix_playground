defmodule Graphql.Resolvers.Menu do
  alias Plateslate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def create_item(_, %{input: params}, _) do
    case Menu.create_item(params) do
      {:error, changeset} ->
        {:error, message: "Could not create menu item", details: error_details(changeset)}

      {:ok, _} = success ->
        success
    end
  end

  def error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
