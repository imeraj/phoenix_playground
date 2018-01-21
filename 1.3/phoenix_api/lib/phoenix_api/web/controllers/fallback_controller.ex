defmodule PhoenixApi.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PhoenixApi.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PhoenixApi.Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(PhoenixApi.Web.ErrorView, :"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(PhoenixApi.Web.ErrorView, :"401")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Authentication required", error: :unauthorized})
  end
end
