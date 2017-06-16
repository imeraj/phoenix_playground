defmodule PhoenixApi.Api.V2.UserController do
  use PhoenixApi.Web, :controller

  def index(conn, _params) do
    json conn, %{version: "v2"}
  end
end
