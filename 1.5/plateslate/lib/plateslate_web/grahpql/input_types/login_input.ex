defmodule PlateslateWeb.Graphql.InputTypes.LoginInput do
  use Absinthe.Schema.Notation

  input_object(:login_input) do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end
end
