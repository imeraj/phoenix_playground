defmodule Fan.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Fan.Repo

  alias Fan.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Fan.Accounts.Relationship

  # functions to manage followers/followings relationships
  def followers(user) do
    list = user |> Repo.preload(:followers)
    list.followers
  end

  def followings(user) do
    list = user |> Repo.preload(:followings)
    list.followings
  end

  def follow(current_user, other_user) do
    %Relationship{}
    |> Relationship.changeset(%{follower_id: current_user.id, followed_id: other_user.id})
    |> Repo.insert()
  end

  def unfollow(current_user, other_user) do
    Repo.get_by!(Relationship, follower_id: current_user.id, followed_id: other_user.id)
    |> Repo.delete()
  end

  def following?(current_user, other_user) do
    query =
      from r in Relationship, where: [follower_id: ^current_user.id, followed_id: ^other_user.id]

    Repo.exists?(query)
  end
end
