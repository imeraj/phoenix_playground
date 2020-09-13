defmodule PlateslateWeb.Plugs.AdminAuth do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    with id when not is_nil(id) <- get_session(conn, :employee_id),
         %{} = user <- Plateslate.Accounts.lookup(id, "employee") do
      conn
      |> Plug.Conn.assign(:current_user, user)
      |> Absinthe.Plug.put_options(context: %{current_user: user})
    else
      _ ->
        conn
        |> clear_session
        |> Phoenix.Controller.redirect(to: "/admin/session/new")
    end
  end
end
