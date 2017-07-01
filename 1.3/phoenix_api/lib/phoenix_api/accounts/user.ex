defmodule PhoenixApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixApi.Accounts.User


  schema "accounts_users" do
    field :email, :string
    field :encrypted_password, :string
    field :name, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
  end
end
