defmodule RumblWeb.UserView do
  use RumblWeb, :view

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.name}
  end
end
