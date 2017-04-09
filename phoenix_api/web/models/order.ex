defmodule PhoenixApi.Order do
  use PhoenixApi.Web, :model

  schema "orders" do
    field :total,               :decimal
    belongs_to :user,           PhoenixApi.User
    has_many :order_products, PhoenixApi.OrderProduct
    has_many :orders, through: [:order_products, :order]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:total])
    |> validate_number(:total, greater_than: 0)
    |> assoc_constraint(:user)
  end
end
