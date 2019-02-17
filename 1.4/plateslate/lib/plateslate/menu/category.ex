defmodule Plateslate.Menu.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :description, :string
    field :name, :string, null: false

    has_many :items, Plateslate.Menu.Item

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
  end
end
