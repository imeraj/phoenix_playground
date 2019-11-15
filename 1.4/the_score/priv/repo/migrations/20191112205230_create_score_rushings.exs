defmodule TheScore.Repo.Migrations.CreateRushings do
  use Ecto.Migration

  def change do
    create table(:rushings) do
      add(:name, :string)
      add(:team, :string)
      add(:pos, :string)
      add(:att_per_game, :float)
      add(:att, :integer)
      add(:total_rush, :integer)
      add(:rush_per_yard, :float)
      add(:rush_per_game, :float)
      add(:rush_td, :integer)
      add(:long_rush, :integer)
      add(:rush_1st_down, :integer)
      add(:rush_1st_down_per, :float)
      add(:rush_20_yards, :integer)
      add(:rush_40_yards, :integer)
      add(:fumble, :integer)

      timestamps()
    end
  end
end
