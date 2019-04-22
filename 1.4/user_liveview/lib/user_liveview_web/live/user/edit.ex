defmodule UserLiveviewWeb.UserLive.Edit do
  use Phoenix.LiveView

  alias UserLiveviewWeb.UserLive
  alias UserLiveviewWeb.UserView
  alias UserLiveviewWeb.Router.Helpers, as: Routes
  alias UserLiveview.Accounts

  def mount(%{path_params: %{"id" => id}}, socket) do
    user = Accounts.get_user!(id)

    {:ok,
     assign(socket, %{
       user: user,
       changeset: Accounts.change_user(user)
     })}
  end

  def render(assigns), do: UserView.render("edit.html", assigns)

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      socket.assigns.user
      |> UserLiveview.Accounts.change_user(params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:stop,
         socket
         |> put_flash(:info, "User updated successfully.")
         |> redirect(to: Routes.live_path(socket, UserLive.Show, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
