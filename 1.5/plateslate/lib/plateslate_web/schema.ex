defmodule PlateslateWeb.Schema do
  use Absinthe.Schema
  alias Plateslate.{Repo, Menu}
  import Ecto.Query

  query do
    field :menu_items, list_of(:menu_item), description: "The list of available menu items" do
      arg(:matching, :string)

      resolve(fn
        _, %{matching: name}, _ when is_binary(name) ->
          query = from t in Menu.Item, where: ilike(t.name, ^"%#{name}%")
          {:ok, Repo.all(query)}

        _, _, _ ->
          {:ok, Repo.all(Menu.Item)}
      end)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end
end
