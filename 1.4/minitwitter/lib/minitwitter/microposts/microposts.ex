defmodule Minitwitter.Microposts do
  @moduledoc """
  The Microposts context.
  """

  import Ecto.Query, warn: false
  alias Minitwitter.Repo

  alias Minitwitter.Accounts
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

  def feed_page(user_id, page) do
    following_ids = Accounts.following_ids(user_id)

    query =
      from p in Post,
        where: p.user_id in ^following_ids or p.user_id == ^user_id,
        order_by: [desc: p.inserted_at],
        preload: [:user]

    Repo.paginate(query, page: page)
  end
end
