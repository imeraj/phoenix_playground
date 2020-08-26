defmodule PlateslateWeb.Schema do
  use Absinthe.Schema
  alias Plateslate.{Repo, Menu}

  query do
    field :menu_item, list_of(:menu_item),
          description: "The list of available menu items" do
      resolve(fn end_, _, _ ->
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
