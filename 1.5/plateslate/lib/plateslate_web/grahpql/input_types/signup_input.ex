defmodule PlateslateWeb.Graphql.InputTypes.SignupInput do
  use Absinthe.Schema.Notation

  import_types(PlateslateWeb.Graphql.Enums.Role)

  input_object(:signup_input) do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :role, non_null(:role)
  end
end
