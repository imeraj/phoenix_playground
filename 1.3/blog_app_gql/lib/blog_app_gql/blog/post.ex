defmodule BlogAppGql.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogAppGql.Blog.Post


  schema "blog_posts" do
    field :body, :string
    field :title, :string

    belongs_to :accounts_user, BlogAppGql.Accounts.User, foreign_key: :accounts_user_id

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body, :accounts_user_id])
    |> validate_required([:title, :body, :accounts_user_id])
    |> foreign_key_constraint(:accounts_user_id)
  end
end
