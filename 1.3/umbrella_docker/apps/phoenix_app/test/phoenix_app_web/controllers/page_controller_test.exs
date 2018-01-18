defmodule PhoenixAppWeb.PageControllerTest do
  use PhoenixAppWeb.ConnCase

  describe "GET /" do
    test "without valid credentials", %{conn: conn} do
      conn = get conn, "/"
      assert conn.status == 401
    end

    test "with valid credentials" do
      conn = get conn_with_basic_auth(), "/"
      assert html_response(conn, 200) =~ "Name"
    end
  end


  def conn_with_basic_auth do
    username = Application.get_env(:phoenix_app, :authentication)[:username]
    password = Application.get_env(:phoenix_app, :authentication)[:password]
    basic_auth_header = "Basic " <> Base.encode64("#{username}:#{password}")

    build_conn()
    |> put_req_header("authorization", basic_auth_header)
  end
end
