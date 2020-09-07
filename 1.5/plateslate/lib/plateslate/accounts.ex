defmodule Plateslate.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Plateslate.Repo
  alias Plateslate.Accounts.User
  alias Comeonin.Ecto.Password

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password: digest} <- user,
         true <- Password.valid?(password, digest) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  def lookup(id, role) do
    Repo.get_by(User, id: id, role: role)
  end
end
