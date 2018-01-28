defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  def list_users do
    User
    |> Repo.all()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    User
    |> Repo.get(id)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
