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
    |> assoc_constraint(:order)
    |> assoc_constraint(:product)
  end
end
