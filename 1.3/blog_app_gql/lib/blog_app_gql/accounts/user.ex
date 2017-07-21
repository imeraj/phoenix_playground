defmodule BlogAppGql.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogAppGql.Accounts.User


  schema "accounts_users" do
    field :email, :string
    field :name, :string

		has_many :blog_posts, BlogAppGql.Blog.Post, foreign_key: :accounts_users_id

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
