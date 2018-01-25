defmodule CmsContext.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias CmsContext.Accounts.{User, Credential}

  @moduledoc false

  schema "users" do
    field(:name, :string)
    field(:username, :string)

    has_one(:credential, Credential, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
