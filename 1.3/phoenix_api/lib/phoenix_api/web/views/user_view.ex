defmodule PhoenixApi.Web.UserView do
  use PhoenixApi.Web, :view
  alias PhoenixApi.Web.UserView

  def render("index.v1.json", %{
        users: users,
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      }) do
    %{
      data: render_many(users, UserView, "user.v1.json"),
      page_info: %{
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      }
    }
  end

  def render("show.v1.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.v1.json")}
  end

  def render("user.v1.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email}
  end
end
