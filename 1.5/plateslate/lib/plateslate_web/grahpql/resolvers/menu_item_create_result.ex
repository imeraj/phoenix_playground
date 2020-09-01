defmodule Graphql.Resolvers.MenuItemCreateResult do
  def menu_item_create_result(%Plateslate.Menu.Item{}, _), do: :menu_item
  def menu_item_create_result(%{errors: _}, _), do: :errors
  def menu_item_create_result(_, _), do: nil
end
