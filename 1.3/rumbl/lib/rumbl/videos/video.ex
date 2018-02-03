defmodule Rumbl.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Videos.Video

  @moduledoc false

  @primary_key {:id, Rumbl.Video.Permalink, autogenerate: true}
  schema "videos" do
    field(:description, :string)
    field(:title, :string)
    field(:url, :string)
    field(:slug, :string)
    belongs_to(:user, Rumbl.Accounts.User)
    belongs_to(:category, Rumbl.Videos.Category)
    has_many(:annotaions, Rumbl.Videos.Annotation)

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description, :category_id])
    |> slugify_title()
    |> assoc_constraint(:category)
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  def slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  defimpl Phoenix.Param, for: Rumbl.Videos.Video do
    def to_param(%{id: id, slug: slug}) do
      "#{id}-#{slug}"
    end
  end
end
