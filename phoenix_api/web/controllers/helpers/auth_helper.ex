defmodule PhoenixApi.AuthHelper do
  import Comeonin.Bcrypt, only: [checkpw: 2]

  def remove_token(conn) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
  end

  def login_by_username_pass(email, given_pass) do
    user = PhoenixApi.Repo.get_by(PhoenixApi.User, email: email)

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
