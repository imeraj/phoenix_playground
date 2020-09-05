defmodule PlateslateWeb.Graphql.Types.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :role, :string
  end
end
