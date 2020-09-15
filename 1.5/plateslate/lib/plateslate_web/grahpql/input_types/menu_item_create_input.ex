defmodule PlateslateWeb.Graphql.InputTypes.MenuItemCreateInput do
  use Absinthe.Schema.Notation

  input_object(:menu_item_create_input) do
    field :name, non_null(:string)
    field :description, :string
    field :price, non_null(:decimal)
    field :category_id, non_null(:id)
  end
end
