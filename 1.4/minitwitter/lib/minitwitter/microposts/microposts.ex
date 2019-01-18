defmodule Minitwitter.Microposts do
  @moduledoc """
  The Microposts context.
  """

  import Ecto.Query, warn: false
  alias Minitwitter.Repo

  alias Minitwitter.Microposts.Post

  def list_posts do
    Post
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def get_posts_page(user, page) do
    Post
    |> where([p], p.user_id == ^user.id)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(page: page)
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
