defmodule Plateslate.Menu do
  import Ecto.Query, warn: false
  alias Plateslate.Repo

  alias Plateslate.Menu.Item

  def list_items(%{matching: name}) when is_binary(name) do
    Item
    |> where([m], like(m.name, ^"%#{name}%"))
    |> Repo.all()
  end

  def list_items(_) do
    Repo.all(Item)
  end
end
