defmodule TheScoreWeb.ScoreController do
  use TheScoreWeb, :controller

  alias TheScore.Rushings

  def index(conn, params) do
    page = Rushings.list_rushings(params)

    render(conn, "index.html", rushings: page.entries, page: page)
  end

  def filter(
        conn,
        %{
          "filter" => %{"name" => name}
        } = params
      ) do
    page = Rushings.filter_rushings(String.trim(name), params)

    render(conn, "index.html", rushings: page.entries, page: page)
  end

  def sort(conn, %{"sort" => %{"sort_criteria" => criteria_id}} = params) do
    :ets.insert(:cache, {"sort_criteria", criteria_id})
    data = Rushings.sort_rushings(criteria_id)

    render(conn, "sorted.html", rushings: data)
  end
end
