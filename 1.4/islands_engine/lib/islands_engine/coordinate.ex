defmodule IslandsEngine.Coordinate do
    alias __MODULE__

    @board_range 1..10

    @enforce_keys [:row, :col]
    defstruct [:row, :col]

    def new(row, col) when row in (@board_range) and col in (@board_range) do
        {:ok, %Coordinate{row: row, col: col}}
    end

    def new(_row, _col) do
        {:error, :invalid_coordinate}
    end
end