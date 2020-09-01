defmodule PlateslateWeb.Graphql.Types.Order do
  use Absinthe.Schema.Notation

  object :order do
    field :id, :id
    field :customer_number, :integer
    field :items, list_of(:order_item)
    field :state, :string
  end

  object :order_item do
    field :name, :string
    field :quantity, :integer
  end
end
