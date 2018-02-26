defmodule BlogAppGql.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogAppGql.Accounts.User

  schema "accounts_users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    has_many(:blog_posts, BlogAppGql.Blog.Post, foreign_key: :accounts_user_id)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 3, max: 10)
    |> validate_length(:password, min: 5, max: 20)
    |> unique_constraint(:email, downcase: true)
  end
end
