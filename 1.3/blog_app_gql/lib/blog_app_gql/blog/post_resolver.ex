defmodule BlogAppGql.Web.Blog.PostResolver do
  alias BlogAppGql.Blog

  def all(_args, _info) do
    {:ok, Blog.list_posts()}
  end

  def find(%{id: id}, _info) do
    case Blog.get_post_by_id(id) do
      nil -> {:error, "Post id #{id} not found"}
      post -> {:ok, post}
    end
  end

  def create(args, _info) do
    Blog.create_post(args)
  end

  def update(%{id: id, post: post_params}, _info) do
    case find(%{id: id}, _info) do
      {:ok, post} -> post |> Blog.update_post(post_params)
      {:error, _} -> {:error, "Post id #{id} not found"}
    end
  end

  def delete(%{id: id}, _info) do
    case find(%{id: id}, _info) do
      {:ok, post} -> post |> Blog.delete_post()
      {:error, _} -> {:error, "Post id #{id} not found"}
    end
  end
end
