defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :sku, :unit_price])
    |> validate_required([:name, :description, :sku, :unit_price])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end
end
