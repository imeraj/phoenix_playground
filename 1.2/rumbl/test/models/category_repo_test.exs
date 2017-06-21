defmodule Rumbl.CategoryRepoTest do
  use Rumbl.ModelCase

  alias Rumbl.Category
  alias Rumbl.Repo

	test "alphabetical/1 orders by name" do
	  Repo.insert!(%Category{name: "c"})
	  Repo.insert!(%Category{name: "b"})
	  Repo.insert!(%Category{name: "a"})

	  query = Category |> Category.alphabatical()
	  query = from c in query, select: c.name
	  assert Repo.all(query) == ~w(a b c)
	end

end