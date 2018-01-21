defmodule PhoenixApi.Sales.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixApi.Sales.Order

  schema "sales_orders" do
    field(:total, :decimal)
    field(:accounts_users_id, :id)

    many_to_many(:sales_products, PhoenixApi.Sales.Product, join_through: "sales_orders_products")

    timestamps()
  end

  @doc false
  def changeset(%Order{} = order, %{"product_ids" => ids} = attrs) do
    order
    |> cast(attrs, [:total, :accounts_users_id])
    |> validate_required([:total, :accounts_users_id])
    |> validate_number(:total, greater_than: 0)
    |> foreign_key_constraint(:accounts_users_id)
    |> put_assoc(:sales_products, PhoenixApi.Sales.get_products_by_ids(ids))
  end
end
