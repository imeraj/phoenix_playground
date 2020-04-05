defmodule HelloSocketsWeb.PageController do
  use HelloSocketsWeb, :controller

  @fake_user_id 1

  def index(conn, _params) do
    conn
    |> assign(:auth_token, generate_auth_token(conn, @fake_user_id))
    |> assign(:user_id, @fake_user_id)
    |> render("index.html")
  end

  defp generate_auth_token(conn, user_id) do
    salt =  Application.get_env(:hello_sockets, HelloSocketsWeb.Endpoint)[:secret_key_base]
    Phoenix.Token.sign(conn, salt, user_id)
  end
end




