defmodule CmsContext.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  alias CmsContext.Repo

  alias CmsContext.CMS.{Page, Author}
  alias CmsContext.Accounts.User

  def list_pages do
    Page
    |> Repo.all()
    |> Repo.preload(author: [user: :credential])
  end

  def get_page!(id) do
    Page
    |> Repo.get!(id)
    |> Repo.preload(author: [user: :credential])
  end

  def create_page(%Author{} = author, attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Repo.insert()
  end

  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end

  alias CmsContext.CMS.Author

  def list_authors do
    Repo.all(Author)
  end

  def get_author!(id) do
    Author
    |> Repo.get!(id)
    |> Repo.preload(user: :credential)
  end

  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  def inc_page_views(%Page{} = page) do
    Repo.update_all(from(p in Page, where: p.id == ^page.id), inc: [views: 1])
    get_page!(page.id)
  end

  def ensure_author_exists(%User{} = user) do
    %Author{user_id: user.id}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_author()
  end

  defp handle_existing_author({:ok, author}), do: author

  defp handle_existing_author({:error, changeset}) do
    Repo.get_by!(Author, user_id: changeset.data.user_id)
  end
end
