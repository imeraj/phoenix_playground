# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%Rumbl.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Rumbl.Repo
alias Rumbl.User

Repo.insert!(%User{name: "Meraj", username: "meraj", password_hash: "secret"})
Repo.insert!(%User{name: "Jose", username: "jose", password_hash: "secret"})
Repo.insert!(%User{name: "Chris", username: "chris", password_hash: "secret"})
