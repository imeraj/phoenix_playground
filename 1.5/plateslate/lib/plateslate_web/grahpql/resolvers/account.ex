defmodule Graphql.Resolvers.Account do
  alias Plateslate.Accounts
  alias PlateslateWeb.Graphql.Authentication

  def signup(_, %{input: params}, _) do
    with {:ok, user} <- Accounts.create_user(params) do
      {:ok, user}
    end
  end

  def login(_, %{input: %{email: email, password: password}}, _) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        token =
          Authentication.sign(%{
            role: user.role,
            id: user.id
          })

        {:ok, %{token: token, user: user}}

      _ ->
        {:error, "incorrect email or password"}
    end
  end
end
