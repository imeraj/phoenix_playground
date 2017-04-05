# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixApi.Repo.insert!(%PhoenixApi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Query, only: [from: 2]
import Integer, only: [is_even: 1]
alias PhoenixApi.Repo

for _x <- 1..50, do:
  Repo.insert! %PhoenixApi.User{
     name: Faker.Name.name,
     email: Faker.Internet.email,
     encrypted_password: Comeonin.Bcrypt.hashpwsalt("password")
  }

query = from u in "users",
        select: u.id
ids = Repo.all(query)
Enum.each(ids, fn id ->
  for i <- 1..50, do:
    Repo.insert! %PhoenixApi.Product{
       title: Faker.Commerce.product_name,
       price: Faker.Commerce.price,
       published: if(is_even(i), do: true, else: false),
       user_id: id
    }
  end
)
