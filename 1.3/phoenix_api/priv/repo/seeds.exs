# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixApi.Repo.insert!(%PhoenixApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule PhoenixApi.DevelopmentSeeder do
  import Ecto.Query, only: [from: 2]
  import Integer, only: [is_even: 1]

  alias PhoenixApi.Accounts
  alias PhoenixApi.Sales
	alias PhoenixApi.Repo

  def insert_data do
    for _<- 1..20, do:
      Repo.insert! %Accounts.User {
         name: Faker.Name.name,
         email: Faker.Internet.email,
         encrypted_password: Comeonin.Bcrypt.hashpwsalt("password")
      }

    query = from u in "accounts_users",
            select: u.id
    ids = Repo.all(query)
    Enum.each(ids, fn id ->
      for i <- 1..50, do:
        Repo.insert! %Sales.Product {
           title: Faker.Commerce.product_name,
           price: Faker.Commerce.price,
           published: is_even(i),
           accounts_users_id: id
        }
      end
    )
  end
end

case Mix.env() do
    :dev ->
        PhoenixApi.DevelopmentSeeder.insert_data()
    _ -> :ignore
end