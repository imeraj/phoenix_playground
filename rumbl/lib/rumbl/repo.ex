defmodule Rumbl.Repo do
  # use Ecto.Repo, otp_app: :rumbl
  alias Rumbl.User

  @moduledoc """
  In memory repository
  """
  def all(User) do
    [
      %User{id: "1", name: "Meraj", username: "meraj", password: "secret"},
      %User{id: "2", name: "Jose", username: "jose", password: "secret"},
      %User{id: "3", name: "Chris", username: "chris", password: "secret"}
     ]
  end
  def all(_module), do: []

  def get(module, id) do
    Enum.find(all(module), fn map -> map.id == id end)
  end

  def get_by(module, params) do
    Enum.find(all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end) end)
  end
end
