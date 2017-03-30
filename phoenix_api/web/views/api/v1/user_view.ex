defmodule PhoenixApi.Api.V1.UserView do
  use PhoenixApi.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, PhoenixApi.Api.V1.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, PhoenixApi.Api.V1.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end
end
