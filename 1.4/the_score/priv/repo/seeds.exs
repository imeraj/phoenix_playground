# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TheScore.Repo.insert!(%TheScore.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule TheScoreWeb.DevelopmentSeeder do
  alias TheScore.Rushings

  def insert_data do
    rushings =
      file()
      |> File.stream!()
      |> Jaxon.Stream.query([:root, :all])
      |> Enum.to_list()

    Enum.each(rushings, fn rushing ->
      new_rushing =
        Map.new([
          {"name", rushing["Player"]},
          {"team", rushing["Team"]},
          {"pos", rushing["Pos"]},
          {"att_per_game", rushing["Att/G"]},
          {"att", rushing["Att"]},
          {"total_rush", rushing["Yds"]},
          {"rush_per_yard", rushing["Avg"]},
          {"rush_per_game", rushing["Yds/G"]},
          {"rush_td", rushing["TD"]},
          {"long_rush", rushing["Lng"]},
          {"rush_1st_down", rushing["1st"]},
          {"rush_1st_down_per", rushing["1st%"]},
          {"rush_20_yards", rushing["20+"]},
          {"rush_40_yards", rushing["40+"]},
          {"fumble", rushing["FUM"]}
        ])

      Rushings.create_rushing(new_rushing)
    end)
  end

  defp file() do
    Path.join(:code.priv_dir(:the_score), "data/rushing.json")
  end
end

case Mix.env() do
  :dev ->
    TheScoreWeb.DevelopmentSeeder.insert_data()

  _ ->
    :ignore
end
