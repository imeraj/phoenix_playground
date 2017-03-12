defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
     field :name, :string
     field :username, :string
     field :password, :string, virtual: true
     field :password_hash, :string

     timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :username, :password])
    |> validate_length(:username, min: 3, max: 10)
  end
end
