defmodule BlogAppGql.Blog.PostResolver do
  alias BlogAppGql.Blog

  def all(_args, %{context: %{current_user: current_user}}) do
    {:ok, Blog.list_posts()}
  end

  def all(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: _current_user}}) do
    case Blog.get_post_by_id(id) do
      nil -> {:error, "Post id #{id} not found"}
      post -> {:ok, post}
    end
  end

  def find(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: _current_user}}) do
    Blog.create_post(args)
  end

  def create(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def update(%{id: id, post: post_params}, %{context: %{current_user: _current_user}} = info) do
    case find(%{id: id}, info) do
      {:ok, post} -> post |> Blog.update_post(post_params)
      {:error, _} -> {:error, "Post id #{id} not found"}
    end
  end

  def update(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def delete(%{id: id}, %{context: %{current_user: _current_user}} = info) do
    case find(%{id: id}, info) do
      {:ok, post} -> post |> Blog.delete_post()
      {:error, _} -> {:error, "Post id #{id} not found"}
    end
  end

  def delete(_args, _info) do
	  {:error, "Not Authorized"}
  end
end
