defmodule CmsContext.CMS.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias CmsContext.CMS.{Page, Author}

  schema "pages" do
    field(:body, :string)
    field(:title, :string)
    field(:views, :integer, default: 0)

    belongs_to(:author, Author)

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
