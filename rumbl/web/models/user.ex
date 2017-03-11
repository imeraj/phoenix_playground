defmodule Rumbl.User do
  @enforce_keys [:id, :username]
  defstruct [:id, :name, :username, :password]
end
