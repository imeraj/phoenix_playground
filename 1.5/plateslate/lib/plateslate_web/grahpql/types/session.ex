defmodule PlateslateWeb.Graphql.Types.Session do
  use Absinthe.Schema.Notation

  object :session do
    field :token, :string
    field :user, :user
  end
end
