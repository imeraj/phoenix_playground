defmodule PlateslateWeb.Graphql.Types.SignupResult do
  use Absinthe.Schema.Notation
  alias(Graphql.Resolvers.SignupResult)

  union :signup_result do
    types([:customer, :employee, :errors])

    resolve_type(&SignupResult.signup_result/2)
  end
end
