defmodule PlateslateWeb.Graphql.Types.Error do
  use Absinthe.Schema.Notation

  object :errors do
    field :errors, list_of(:error)
  end

  @desc "An error encountered"
  object :error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end
end
