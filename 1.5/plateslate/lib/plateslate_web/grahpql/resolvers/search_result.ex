defmodule Graphql.Resolvers.SearchResult do
  alias Plateslate.Menu

  def search(_, %{matching: term}, _) do
    {:ok, Menu.search(term)}
  end
end
