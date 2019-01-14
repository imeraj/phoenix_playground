# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Minitwitter.Repo.insert!(%Minitwitter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule MinitwitterWeb.DevelopmentSeeder do
  alias Minitwitter.Accounts
  alias Minitwitter.Repo

  def insert_data do
    Repo.insert!(%Accounts.User{
      name: "Meraj",
      email: "meraj.enigma@gmail.com",
      password: "phoenix",
      password_hash: Comeonin.Pbkdf2.hashpwsalt("phoenix"),
      admin: true
    })

    for _ <- 1..100,
        do:
          Repo.insert!(%Accounts.User{
            name: Faker.Name.name(),
            email: Faker.Internet.email(),
            password: "phoenix",
            password_hash: Comeonin.Pbkdf2.hashpwsalt("phoenix")
          })
  end
end

case Mix.env() do
  :dev ->
    MinitwitterWeb.DevelopmentSeeder.insert_data()

  _ ->
    :ignore
end
