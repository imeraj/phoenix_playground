defmodule Graphql.Resolvers.SignupResult do
  def signup_result(%Plateslate.Accounts.User{}, _), do: :user
  def signup_result(%{errors: _}, _), do: :errors
  def signup_result(_, _), do: nil
end
