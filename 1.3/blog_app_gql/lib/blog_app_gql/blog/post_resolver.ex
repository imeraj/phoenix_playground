defmodule BlogAppGql.Web.Blog.PostResolver do
	alias BlogAppGql.Blog

  def all(_args, _info) do
    {:ok, Blog.list_posts()}
  end

  def find(%{id: id}, _info) do
    case Blog.get_post_by_id(id) do
      nil  -> {:error, "Post id #{id} not found"}
      post -> {:ok, post}
    end
  end

	def create(args, _info) do
		Blog.create_post(args)
	end

	def update(%{id: id, post: post_params}, _info) do
    Blog.get_post!(id)
    |> Blog.update_post(post_params)
  end

	def delete(%{id: id}, _info) do
		post = Blog.get_post!(id)
		Blog.delete_post(post)
	end
end