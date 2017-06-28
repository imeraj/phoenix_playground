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
defmodule Rumbl.DevelopmentSeeder do
  alias Rumbl.Repo
  alias Rumbl.Category

  @category_list ~w(Action Drama Romance Comedy Sci-fi Educational)

  def insert_data do
    for category <- @category_list do
        Repo.insert!(%Category{name: category})
    end
  end
end

case Mix.env() do
	:dev ->
        Rumbl.DevelopmentSeeder.insert_data()
    _ -> :ignore
end

