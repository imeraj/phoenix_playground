defmodule BlogAppGql.Web.Accounts.UserResolver do
  alias BlogAppGql.Accounts

  def all(_args, _info) do
    {:ok, Accounts.list_users()}
  end

  def find(%{email: email}, _info) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, "User email #{email} not found!"}
      user -> {:ok, user}
    end
  end
end