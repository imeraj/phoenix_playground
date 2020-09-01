defmodule PlateslateWeb.Graphql.InputTypes.OrderPlaceInput do
  use Absinthe.Schema.Notation

  input_object(:order_place_input) do
    field :customer_number, :integer
    field :items, non_null(list_of(non_null(:order_item_input)))
  end

  input_object(:order_item_input) do
    field :menu_item_id, non_null(:id)
    field :quantity, non_null(:integer)
  end
end
