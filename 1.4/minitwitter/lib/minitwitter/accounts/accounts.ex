defmodule Minitwitter.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Minitwitter.Repo

  alias Minitwitter.Accounts.User

  def list_users(params) do
    User
    |> Minitwitter.Repo.paginate(params)
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  defp new_token(), do: User.new_token()

  def remember_user(user) do
    token = new_token()

    update_user(
      user,
      %{remember_hash: Comeonin.Pbkdf2.hashpwsalt(token)}
    )

    token
  end

  def forget_user(user) do
    update_user(
      user,
      %{remember_hash: nil}
    )
  end

  def authenticated?(user, remember_token) do
    cond do
      user.remember_hash && Comeonin.Pbkdf2.checkpw(remember_token, user.remember_hash) ->
        true

      true ->
        Comeonin.Bcrypt.dummy_checkpw()
        false
    end
  end

  def authenticate_by_email_and_pass(email, given_pass) do
    user = get_user_by(%{email: email})

    cond do
      user && Comeonin.Pbkdf2.checkpw(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, :not_found}
    end
  end
end
