defmodule UserLiveviewWeb.UserLive.Index do
  use Phoenix.LiveView

  alias UserLiveview.Accounts
  alias UserLiveviewWeb.UserView

  def mount(_session, socket) do
    {:ok, fetch(socket)}
  end

  def render(assigns), do: UserView.render("index.html", assigns)

  defp fetch(socket) do
    assign(socket, users: Accounts.list_users())
  end

  def handle_event("delete_user", id, socket) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)
    {:noreply, fetch(socket) }
  end
end
