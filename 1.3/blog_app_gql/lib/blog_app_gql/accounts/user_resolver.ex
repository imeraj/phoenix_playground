defmodule BlogAppGql.Web.Accounts.UserResolver do
  alias BlogAppGql.Accounts

  def all(_args, _info) do
    {:ok, Accounts.list_users()}
  end
end