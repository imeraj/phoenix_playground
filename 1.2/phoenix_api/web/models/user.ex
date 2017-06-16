defmodule PhoenixApi.User do
  use PhoenixApi.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    has_many :products, PhoenixApi.Product
    has_many :orders, PhoenixApi.Order

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email, downcase: true)
    |> validate_length(:password, min: 5)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
      _->
        changeset
    end
  end
end
