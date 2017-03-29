defmodule PhoenixApi.Api.V1.UserController do
  use PhoenixApi.Web, :controller

  def index(conn, _params) do
    json conn, %{version: "v1"}
  end
end
