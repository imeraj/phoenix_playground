defmodule Fresco.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :brand_colour, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :brand_colour])
    |> validate_required([:name, :brand_colour])
    |> unique_constraint(:name)
  end
end
