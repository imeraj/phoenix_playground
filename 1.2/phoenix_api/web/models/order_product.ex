defmodule PhoenixApi.OrderProduct do
  use PhoenixApi.Web, :model

  schema "order_products" do
    belongs_to :order,      PhoenixApi.Order
    belongs_to :product,    PhoenixApi.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:order_id)
  end
end
