defmodule BlogAppGql.Web.PostControllerTest do
  use BlogAppGql.Web.ConnCase

  alias BlogAppGql.Blog
  alias BlogAppGql.Blog.Post

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates post and renders post when data is valid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, post_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "body" => "some body",
      "title" => "some title"}
  end

  test "does not create post and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen post and renders post when data is valid", %{conn: conn} do
    %Post{id: id} = post = fixture(:post)
    conn = put conn, post_path(conn, :update, post), post: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, post_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "body" => "some updated body",
      "title" => "some updated title"}
  end

  test "does not update chosen post and renders errors when data is invalid", %{conn: conn} do
    post = fixture(:post)
    conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen post", %{conn: conn} do
    post = fixture(:post)
    conn = delete conn, post_path(conn, :delete, post)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, post)
    end
  end
end
