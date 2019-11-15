defmodule TheScore.Rushing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushings" do
    field(:att, :integer)
    field(:att_per_game, :float)
    field(:fumble, :integer)
    field(:long_rush, :integer)
    field(:name, :string)
    field(:pos, :string)
    field(:rush_1st_down, :integer)
    field(:rush_1st_down_per, :float)
    field(:rush_20_yards, :integer)
    field(:rush_40_yards, :integer)
    field(:rush_per_game, :float)
    field(:rush_per_yard, :float)
    field(:rush_td, :integer)
    field(:team, :string)
    field(:total_rush, :integer)

    timestamps()
  end

  @doc false
  def changeset(rushing, attrs) do
    rushing
    |> cast(attrs, [
      :name,
      :team,
      :pos,
      :att_per_game,
      :att,
      :total_rush,
      :rush_per_yard,
      :rush_per_game,
      :rush_td,
      :long_rush,
      :rush_1st_down,
      :rush_1st_down_per,
      :rush_20_yards,
      :rush_40_yards,
      :fumble
    ])
    |> validate_required([
      :name,
      :team,
      :pos,
      :att_per_game,
      :att,
      :total_rush,
      :rush_per_yard,
      :rush_per_game,
      :rush_td,
      :long_rush,
      :rush_1st_down,
      :rush_1st_down_per,
      :rush_20_yards,
      :rush_40_yards,
      :fumble
    ])
  end
end
