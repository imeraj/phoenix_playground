defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context
  """

  alias Rumbl.Accounts.User

  def list_users do
    [
      %User{id: "1", name: "Jose", username: "josevalim"},
      %User{id: "2", name: "Chris", username: "chrismccord"},
      %User{id: "3", name: "Meraj", username: "meraj"},
    ]
  end

  def get_user(id) do
    Enum.find(list_users(), fn user -> user.id == id end)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn user ->
      Enum.all?(params, fn {key, val} -> Map.get(user, key) == val end)
    end)
  end
end
