# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%Rumbl.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Rumbl.Repo
alias Rumbl.Category

case Mix.env() do
	:dev ->
		IO.inspect(Mix.env())
		for category <- ~w(Action Drama Romance Comedy Sci-fi Educational) do
      Repo.insert!(%Category{name: category})
    end
  _ -> :ignore
end

