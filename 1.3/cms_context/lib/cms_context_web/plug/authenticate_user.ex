defp authenticate_user(conn, _) do
  case get_session(conn, :user_id) do
    nil ->
      conn
      |> Phoenix.Contoller.put_flash(:error, "Login required")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt()

    user_id ->
      assign(conn, :current_user, CmsContext.Accounts.get_user!(user_id))
  end
end
