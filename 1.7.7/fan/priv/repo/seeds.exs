# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fan.Repo.insert!(%Fan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Fan.Accounts

for _ <- 1..5,
    do:
      Accounts.create_user(%{
        name: Faker.Name.name(),
        email: Faker.Internet.email()
      })

# Following relationships
users = Accounts.list_users()
user = Enum.at(users, 0)
following = Enum.slice(users, 2, 10)
followers = Enum.slice(users, 3, 10)

for followed <- following, do: Accounts.follow(followed, user)
for follower <- followers, do: Accounts.follow(user, follower)
