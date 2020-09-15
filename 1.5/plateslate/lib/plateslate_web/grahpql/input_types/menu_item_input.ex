defmodule PlateslateWeb.Graphql.InputTypes.MenuItemInput do
  use Absinthe.Schema.Notation

  input_object(:menu_item_input) do
    field :id, non_null(:id)
  end
end
