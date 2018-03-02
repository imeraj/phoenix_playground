defmodule BlogAppGql.Accounts.UserResolver do
  alias BlogAppGql.Accounts

  import BlogAppGql.AuthHelper

  def all(_args, %{context: %{current_user: _current_user}}) do
    {:ok, Accounts.list_users()}
  end

  def all(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def find(%{email: email}, %{context: %{current_user: _current_user}}) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, "User email #{email} not found!"}
      user -> {:ok, user}
    end
  end

  def find(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def login(%{email: email, password: password}, _info) do
    with {:ok, user} <- login_with_email_pass(email, password),
         {:ok, jwt, _} <- BlogAppGql.Guardian.encode_and_sign(user) ,
         {:ok, _ } <- BlogAppGql.Accounts.store_token(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end

  def logout(_args,  %{context: %{current_user: current_user, token: _token}}) do
    BlogAppGql.Accounts.revoke_token(current_user, nil)
    {:ok, current_user}
  end

  def logout(_args, _info) do
    {:error, "Please log in first!"}
  end

  def create(params, _info) do
    Accounts.create_user(params)
  end
end
