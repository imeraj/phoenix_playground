defmodule Graphql.Resolvers.Account do
  alias Plateslate.Accounts

  def signup(_, %{input: params}, _) do
    with {:ok, user} <- Accounts.create_user(params) do
      {:ok, user}
    end
  end
end
