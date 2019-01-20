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
  import Ecto.Query, only: [from: 2]

  alias Minitwitter.Accounts
  alias Minitwitter.Accounts.User
  alias Minitwitter.Microposts
  alias Minitwitter.Repo

  def insert_data do
    # users
    Repo.insert!(%Accounts.User{
      name: "Admin",
      email: "demo.rails007@gmail.com",
      password: "phoenix",
      password_hash: Comeonin.Pbkdf2.hashpwsalt("phoenix"),
      admin: true,
      activated: true,
      activated_at: DateTime.truncate(DateTime.utc_now(), :second)
    })

    for _ <- 1..50,
        do:
          Repo.insert!(%Accounts.User{
            name: Faker.Name.name(),
            email: Faker.Internet.email(),
            password: "phoenix",
            password_hash: Comeonin.Pbkdf2.hashpwsalt("phoenix"),
            activated: true,
            activated_at: DateTime.truncate(DateTime.utc_now(), :second)
          })

    # Microposts
    query =
      from u in "users",
        select: u.id

    ids = Repo.all(query)

    Enum.each(ids, fn id ->
      for _ <- 1..50,
          do:
            Repo.insert!(%Microposts.Post{
              content: Faker.Lorem.sentence(5),
              user_id: id
            })
    end)

    # Follwing relationships
    users = Repo.all(User)
    user = Enum.at(users, 0)
    following = Enum.slice(users, 2, 50)
    followers = Enum.slice(users, 3, 40)
    for followed <- following, do: Minitwitter.Accounts.follow(followed, user)

    for follower <- followers, do: Minitwitter.Accounts.follow(user, follower)
  end
end

case Mix.env() do
  :dev ->
    MinitwitterWeb.DevelopmentSeeder.insert_data()

  _ ->
    :ignore
end
