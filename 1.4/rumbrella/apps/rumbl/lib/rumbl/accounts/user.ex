defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Accounts.Credential

  schema "users" do
    field :name, :string
    field :username, :string

    has_one :credential, Credential

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 3, max: 10)
    |> downcase_username()
    |> unique_constraint(:username)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  defp downcase_username(changeset) do
    case fetch_change(changeset, :username) do
      {:ok, username} -> put_change(changeset, :username, String.downcase(username))
      :error -> changeset
    end
  end
end