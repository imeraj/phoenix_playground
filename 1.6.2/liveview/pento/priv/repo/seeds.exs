# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pento.Repo
alias Pento.Catalog.Product

products = [
  %{
    name: "Chess",
    description: "The classic strategy game",
    sku: 5_678_910,
    unit_price: 10.00
  },
  %{
    name: "Tic-Tac-Toe",
    description: "The game of Xs and 0s",
    sku: 11_121_314,
    unit_price: 3.00
  },
  %{
    name: "Table Tennis",
    description: "Ball the ball back and forth. Don't miss!",
    sku: 15_222_324,
    unit_price: 12.00
  }
]

products =
  products
  |> Enum.map(fn product ->
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    product
    |> Map.put(:inserted_at, now)
    |> Map.put(:updated_at, now)
  end)

Repo.insert_all(Product, products)
