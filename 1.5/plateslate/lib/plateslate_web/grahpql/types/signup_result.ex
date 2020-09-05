defmodule PlateslateWeb.Graphql.Types.SignupResult do
  use Absinthe.Schema.Notation
  alias(Graphql.Resolvers.SignupResult)

  import_types(PlateslateWeb.Graphql.Types.User)

  union :signup_result do
    types([:user, :errors])

    resolve_type(&SignupResult.signup_result/2)
  end
end
