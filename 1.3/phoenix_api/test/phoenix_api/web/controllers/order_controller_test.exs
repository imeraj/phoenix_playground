defmodule PhoenixApi.Web.OrderControllerTest do
  use PhoenixApi.Web.ConnCase

  alias PhoenixApi.Sales
  alias PhoenixApi.Sales.Order

  @create_attrs %{total: "120.5"}
  @update_attrs %{total: "456.7"}
  @invalid_attrs %{total: nil}

  def fixture(:order) do
    {:ok, order} = Sales.create_order(@create_attrs)
    order
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, order_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates order and renders order when data is valid", %{conn: conn} do
    conn = post conn, order_path(conn, :create), order: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, order_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "total" => "120.5"}
  end

  test "does not create order and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, order_path(conn, :create), order: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen order and renders order when data is valid", %{conn: conn} do
    %Order{id: id} = order = fixture(:order)
    conn = put conn, order_path(conn, :update, order), order: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, order_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "total" => "456.7"}
  end

  test "does not update chosen order and renders errors when data is invalid", %{conn: conn} do
    order = fixture(:order)
    conn = put conn, order_path(conn, :update, order), order: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen order", %{conn: conn} do
    order = fixture(:order)
    conn = delete conn, order_path(conn, :delete, order)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, order_path(conn, :show, order)
    end
  end
end
