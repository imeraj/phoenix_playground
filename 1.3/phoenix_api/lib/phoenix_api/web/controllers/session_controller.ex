defmodule PhoenixApi.Web.SessionController do
  use PhoenixApi.Web, :controller
  import PhoenixApi.AuthHelper

  @moduledoc false
  plug(:scrub_params, "session" when action in [:create])

  def create(%{assigns: %{version: :v1}} = conn, %{
        "session" => %{"email" => email, "password" => given_pass}
      }) do
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
        |> json(%{message: "Login failed!", error: reason})
    end
  end

  def destory(%{assigns: %{version: :v1}} = conn, _params) do
    case remove_token(conn) do
      :ok ->
        json(conn, %{message: "Logout successful!"})

      {:error, reason} ->
        conn
        |> json(%{message: "Logout failed!", error: reason})
    end
  end
end
