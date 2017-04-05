defmodule PhoenixApi.Product do
  use PhoenixApi.Web, :model

  schema "products" do
    field :title, :string
    field :price, :decimal
    field :published, :boolean, default: true
    belongs_to :user, PhoenixApi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :price, :published])
    |> validate_required([:title, :price, :published])
    |> validate_number(:price, greater_than: 0)
  end
end
