defmodule TheScoreWeb.CsvController do
  use TheScoreWeb, :controller

  alias TheScore.Rushings

  @columns ~w(name
        team
        pos
        att_per_game
        att
        total_rush
        rush_per_yard
        rush_per_game
        rush_td
        long_rush
        rush_1st_down
        rush_1st_down_per
        rush_20_yards
        rush_40_yards
        fumble)a

  def export(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"thescore.csv\"")
    |> send_resp(200, csv_content())
  end

  defp csv_content do
    criteria =
      case :ets.lookup(:cache, "sort_criteria") do
        [{_, criteria}] -> criteria
        [] -> ""
      end

    [
      [
        "name",
        "team",
        "pos",
        "att_per_game",
        "att",
        "total_rush",
        "rush_per_yard",
        "rush_per_game",
        "rush_td",
        "long_rush",
        "rush_1st_down",
        "rush_1st_down_per",
        "rush_20_yards",
        "rush_40_yards",
        "fumble"
      ]
    ]
    |> Stream.concat(
      Rushings.sort_rushings(criteria)
      |> Enum.map(&parse_line/1)
    )
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  defp parse_line(rushing) do
    Enum.map(@columns, &Map.get(rushing, &1))
  end
end
