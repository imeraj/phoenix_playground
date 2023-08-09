defmodule Fan.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Fan.Accounts.Relationship

  schema "users" do
    field :email, :string
    field :name, :string

    has_many(:active_relationships, Relationship,
      foreign_key: :follower_id,
      on_delete: :delete_all
    )

    has_many(:passive_relationships, Relationship,
      foreign_key: :followed_id,
      on_delete: :delete_all
    )

    has_many(:followings, through: [:active_relationships, :followed])
    has_many(:followers, through: [:passive_relationships, :follower])

    timestamps()
  end

  @email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  @doc false
  def changeset(%__MODULE__{} = user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @email_regex)
  end
end
