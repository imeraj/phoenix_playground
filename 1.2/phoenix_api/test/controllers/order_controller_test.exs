defmodule PhoenixApi.OrderControllerTest do
  use PhoenixApi.ConnCase

  alias PhoenixApi.Order
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, order_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = get conn, order_path(conn, :show, order)
    assert json_response(conn, 200)["data"] == %{"id" => order.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, order_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, order_path(conn, :create), order: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Order, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, order_path(conn, :create), order: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = put conn, order_path(conn, :update, order), order: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Order, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = put conn, order_path(conn, :update, order), order: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    order = Repo.insert! %Order{}
    conn = delete conn, order_path(conn, :delete, order)
    assert response(conn, 204)
    refute Repo.get(Order, order.id)
  end
end
