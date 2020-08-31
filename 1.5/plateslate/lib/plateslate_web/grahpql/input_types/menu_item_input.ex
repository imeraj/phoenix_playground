defmodule PlateslateWeb.Graphql.InputTypes.MenuItemInput do
  use Absinthe.Schema.Notation

  import_types(PlateslateWeb.Graphql.Scalars.Decimal)

  input_object(:menu_item_input) do
    field :name, non_null(:string)
    field :description, :string
    field :price, non_null(:decimal)
    field :category_id, non_null(:id)
  end
end
