defmodule Graphql.Resolvers.Menu do
  alias Plateslate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end
end
