defmodule CmsContext.Accounts do
  alias CmsContext.Accounts.Credential

  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias CmsContext.Repo

  alias CmsContext.Accounts.{User, Credential}

  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:credential)
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:credential)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.put_assoc(
      :credential,
      %Credential{}
      |> Credential.changeset(attrs)
    )
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.put_assoc(
      :credential,
      %Credential{}
      |> Credential.changeset(attrs)
    )
    |> IO.inspect(label: "end")
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
