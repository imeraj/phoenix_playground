defmodule TheScore.Rushings do
  import Ecto.Query

  alias TheScore.Rushing
  alias TheScore.Repo

  @doc false
  def create_rushing(attrs \\ %{}) do
    %Rushing{}
    |> Rushing.changeset(attrs)
    |> Repo.insert()
  end

  @doc false

  def list_rushings(params) do
    Rushing
    |> Repo.paginate(params)
  end

  @doc false
  def filter_rushings(filter, params) do
    Rushing
    |> where(name: ^filter)
    |> Repo.paginate(params)
  end

  @doc false
  def sort_rushings(criteria) do
    case criteria do
      "1" ->
        Repo.all(from(r in Rushing, order_by: ^:total_rush))

      "2" ->
        Repo.all(from(r in Rushing, order_by: ^:long_rush))

      "3" ->
        Repo.all(from(r in Rushing, order_by: ^:rush_td))

      _ ->
        Repo.all(from(r in Rushing))
    end
  end
end
