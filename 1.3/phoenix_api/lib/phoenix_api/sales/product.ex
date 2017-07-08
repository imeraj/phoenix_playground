defmodule PhoenixApi.Sales.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixApi.Sales.Product


  schema "sales_products" do
    field :price, :decimal
    field :published, :boolean, default: true
    field :title, :string
    field :accounts_users_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:title, :price, :published, :accounts_users_id])
    |> validate_required([:title, :price, :published, :accounts_users_id])
    |> validate_number(:price, greater_than: 0)
  end
end
