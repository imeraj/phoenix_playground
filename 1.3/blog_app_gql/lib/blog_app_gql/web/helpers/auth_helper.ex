defmodule BlogAppGql.AuthHelper do
  @moduledoc false

  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias BlogAppGql.Repo
  alias BlogAppGql.Accounts.User

  def login_with_email_pass(email, given_pass) do
    IO.inspect email
    IO.inspect(given_pass)
    user = Repo.get_by(User, email: String.downcase(email))
    IO.inspect(user)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, "Incorrect login credentials"}

      true ->
        {:error, :"User not found"}
    end
  end
end
