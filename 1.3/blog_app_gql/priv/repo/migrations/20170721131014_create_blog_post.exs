defmodule BlogAppGql.Repo.Migrations.CreateBlogAppGql.Blog.Post do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :title, :string
      add :body, :text
      add :accounts_users_id, references(:accounts_users, on_delete: :nothing)

      timestamps()
    end

    create index(:blog_posts, [:accounts_users_id])
  end
end
