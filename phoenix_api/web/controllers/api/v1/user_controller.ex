defmodule PhoenixApi.Api.V1.UserController do
  use PhoenixApi.Web, :controller
  alias PhoenixApi.Repo
  alias PhoenixApi.User

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
    {:ok, user} ->
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> json("Registration successful")
    {:error, changeset} ->
      respose = changeset.errors |> Poison.encode!
      IO.inspect respose
      conn
      |> put_status(:unprocessable_entity)
      |> json("")
      |> halt
    end
  end
end
