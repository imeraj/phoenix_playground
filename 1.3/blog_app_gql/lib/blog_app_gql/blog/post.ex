defmodule BlogAppGql.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogAppGql.Blog.Post


  schema "blog_posts" do
    field :body, :string
    field :title, :string

    belongs_to :accounts_users, BlogAppGql.Accounts.User, foreign_key: :accounts_users_id

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
