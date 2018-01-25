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
    |> Ecto.Changeset.put_assoc(:credential, %Credential{} |> Credential.changeset(attrs))
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:credential, %Credential{} |> Credential.changeset(attrs))
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_by_email_password(email, _password) do
    query =
      from(
        u in User,
        inner_join: c in assoc(u, :credential),
        where: c.email == ^email
      )

    case Repo.one(query) do
      %User{} = user -> {:ok, user}
      nil -> {:error, :unauthorized}
    end
  end
end
