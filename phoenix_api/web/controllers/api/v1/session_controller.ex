defmodule PhoenixApi.Api.V1.SessionController do
  import PhoenixApi.AuthHelper
  use PhoenixApi.Web, :controller

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => %{"email" => email, "password" => given_pass}}) do
    case login_by_username_pass(email, given_pass) do
      {:ok, user} ->
          auth_conn = Guardian.Plug.api_sign_in(conn, user)
          jwt = Guardian.Plug.current_token(auth_conn)
          {:ok, claims} = Guardian.Plug.claims(auth_conn)
          exp = Map.get(claims, "exp")

          auth_conn
          |> put_resp_header("authorization", "Bearer #{jwt}")
          |> put_resp_header("x-expires", "#{exp}")
          |> json(%{access_token: jwt, expires_in: exp})
      {:error, reason} ->
          conn
          |> put_status(reason)
          |> json(%{message: "Login failed!", reason: reason})
    end
  end

  def destory(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    case Guardian.Plug.claims(conn) do
      {:ok, claims} ->
        case Guardian.revoke!(jwt, claims) do
          :ok ->
            conn
            |> json(%{message: "Logout successful!"})
          {:error, reason}->
            conn
            |>json(%{message: "Logout failed!", error: reason})
        end
      {:error, reason} ->
        conn
        |>json(%{message: "Logout failed!", error: reason})
    end
  end
end
