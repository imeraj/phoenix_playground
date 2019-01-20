defmodule Minitwitter.Microposts.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :picture, Minitwitter.ImageUploader.Type

    belongs_to(:user, Minitwitter.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :user_id])
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, min: 1, max: 140)
    |> foreign_key_constraint(:user_id)
  end
end
