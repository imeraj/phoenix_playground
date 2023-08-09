defmodule Fan.Accounts.Relationship do
  use Ecto.Schema
  import Ecto.Changeset

  alias Fan.Accounts.User

  schema "relationships" do
    belongs_to(:follower, User)
    belongs_to(:followed, User)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = relationship \\ __MODULE__, attrs) do
    relationship
    |> cast(attrs, [:follower_id, :followed_id])
    |> validate_required([:follower_id, :followed_id])
    |> foreign_key_constraint(:follower_id)
    |> foreign_key_constraint(:followed_id)
  end
end
