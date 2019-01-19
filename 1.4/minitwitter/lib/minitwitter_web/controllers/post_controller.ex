defmodule MinitwitterWeb.PostController do
  use MinitwitterWeb, :controller

  alias Minitwitter.Microposts
  alias Minitwitter.Microposts.Post
  alias Minitwitter.Accounts

  plug :authenticate_user when action in [:index, :create, :delete]

  def index(conn, %{"user_id" => id, "page" => page}) do
    user = Accounts.get_user(id)
    page = Microposts.get_posts_page(user, page)

    conn
    |> put_view(MinitwitterWeb.UserView)
    |> render("show.html",
      user: user,
      page: page,
      posts: page.entries,
      changeset: Microposts.change_post(%Post{})
    )
  end

  def create(conn, %{"user_id" => user_id, "post" => post_params}) do
    post_params = Map.put(post_params, "user_id", user_id)

    case Microposts.create_post(post_params) do
      {:ok, post} ->
        user = Accounts.get_user(user_id)

        conn
        |> put_flash(:info, "Micrpost created.")
        |> put_view(MinitwitterWeb.UserView)
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        user = Accounts.get_user(user_id)
        page = Microposts.get_posts_page(user, 1)

        conn
        |> put_view(MinitwitterWeb.UserView)
        |> render("show.html", user: user, page: page, posts: page.entries, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => post_id}) do
    post = Microposts.get_post!(post_id)

    conn =
      if post.user_id == String.to_integer(user_id) do
        Microposts.delete_post(post)
        conn |> put_flash(:info, "Micropost deleted.")
      else
        conn
      end

    user = Accounts.get_user(user_id)

    conn
    |> put_view(MinitwitterWeb.UserView)
    |> redirect(to: Routes.user_path(conn, :show, user))
  end
end
