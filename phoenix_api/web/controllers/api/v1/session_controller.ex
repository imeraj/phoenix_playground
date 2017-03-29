defmodule PhoenixApi.Api.V1.SessionController do
  use PhoenixApi.Web, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2]

  def create(conn, %{"session" => %{"email" => email, "password" => given_pass}}) do
    case login_by_username_pass(email, given_pass) do
        {:ok, _user} ->
            conn
            |> json("logged in")
        {:error, _reason} ->
            IO.puts "error"
            conn
            |> json("error")
    end
  end

  defp login_by_username_pass(email, given_pass) do
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
