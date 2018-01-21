defmodule PhoenixApi.AuthHelper do
  @moduledoc false

  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias PhoenixApi.Repo
  alias PhoenixApi.Accounts.User

  def remove_token(conn) do
    jwt = Guardian.Plug.current_token(conn)

    case Guardian.Plug.claims(conn) do
      {:ok, claims} ->
        Guardian.revoke!(jwt, claims)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def login_by_username_pass(email, given_pass) do
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(given_pass, user.encrypted_password) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        {:error, :not_found}
    end
  end
end
