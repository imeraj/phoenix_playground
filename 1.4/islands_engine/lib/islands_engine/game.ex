defmodule IslandsEngine.Game do
    use GenServer

    alias IslandsEngine.{Board, Guesses, Rules, Coordinate, Island}

    @players [:player1, :player2]

    def start_link(name) when is_binary(name) do
        GenServer.start_link(__MODULE__, name, [])
    end

    def init(name) do
        player1 = %{name: name, board: Board.new(), guesses: Guesses.new()}
        player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}
        {:ok, %{player1: player1, player2: player2, rules: %Rules{}}}
    end

    def add_player(game, name) when is_binary(name), do:
        GenServer.call(game, {:add_player, name})

    def position_island(game, player, key, row, col) when player in @players, do:
        GenServer.call(game, {:position_island, player, key, row, col})

    def set_islands(game, player) when player in @players, do:
        GenServer.call(game, {:set_island, player})

    def handle_call({:add_player, name}, _from, state) do
        with {:ok, rules} <- Rules.check(state.rules, :add_player)
        do
            state
            |> update_player2_name(name)
            |> update_rules(rules)
            |> reply_success(:ok)
        else
            :error -> {:reply, :error, state}
        end
    end

    def handle_call({:position_island, player, key, row, col}, _from, state) do
        board = player_board(state, player)

        with {:ok, rules} <- Rules.check(state.rules, {:position_islands, player}),
             {:ok, coordinate} <- Coordinate.new(row, col),
             {:ok, island} <- Island.new(key, coordinate),
             %{} = board <- Board.position_island(board, key, island)
        do
            state
            |> update_board(player, board)
            |> update_rules(rules)
            |> reply_success(:ok)
        else
            :error
                -> {:reply, :error, state}
            {:error, :invalid_coordinate}
                -> {:reply, {:error, :invalid_coordinate}, state}
            {:error, :invalid_island_type}
                -> {:reply, {:error, :invalid_island_type}, state}
            {:error, :overlapping_island}
                -> {:reply, {:error, :overlapping_island}, state}
        end
    end

    def handle_call({:set_island, player}, _from, state) do
        board = player_board(state, player)

        with {:ok, rules} <- Rules.check(state.rules, {:set_islands, player}),
             true <- Board.all_islands_positioned?(board)
        do
            state
            |> update_rules(rules)
            |> reply_success({:ok, board})
        else
            :error -> {:reply, :error, state}
            false -> {:reply, {:error, :not_all_islands_positioned}, state}
        end
    end

    defp update_player2_name(state, name), do:
        put_in(state.player2.name, name)

    defp update_rules(state, rules), do:
        %{state | rules: rules}

    defp reply_success(state, reply), do:
        {:reply, reply, state}

    defp update_board(state, player, board), do:
        Map.update!(state, player, fn player -> %{player | board: board} end)

    defp player_board(state, player), do:
        Map.get(state, player).board
end
