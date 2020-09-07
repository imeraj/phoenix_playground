defmodule Graphql.Resolvers.SignupResult do
  use Absinthe.Schema.Notation

  def signup_result(%Plateslate.Accounts.User{} = user, _) do
    case user.role do
      "customer" -> :customer
      "employee" -> :employee
    end
  end

  def signup_result(%{errors: _}, _), do: :errors
  def signup_result(_, _), do: nil
end
