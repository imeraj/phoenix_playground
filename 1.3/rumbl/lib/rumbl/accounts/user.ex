defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Accounts.User

  schema "users" do
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
    |> validate_length(:username, min: 3, max: 10)
    |> validate_length(:password, min: 5, max: 10)
    |> unique_constraint(:username)
  end
end
