defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
     field :name, :string
     field :username, :string
     field :password, :string, virtual: true
     field :password_hash, :string
     has_many :videos, Rumbl.Video

     timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
    |> validate_length(:username, min: 3, max: 10)
    |> validate_length(:password, min: 5, max: 15)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _->
        changeset
    end
  end
end
