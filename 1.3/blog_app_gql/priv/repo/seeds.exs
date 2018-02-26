# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BlogAppGql.Repo.insert!(%BlogAppGql.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BlogAppGql.Repo
alias BlogAppGql.Accounts.User
alias BlogAppGql.Blog.Post

# Create 10 seed users

for _ <- 1..10 do
  Repo.insert!(%User{
    name: Faker.Name.name,
    email: Faker.Internet.safe_email(),
    password: "password"
  })
end

# Create 40 seed posts
for _ <- 1..40 do
  Repo.insert!(%Post{
    title: Faker.Lorem.sentence,
    body: Faker.Lorem.sentences(%Range{first: 1, last: 3}) |> Enum.join("\n\n"),
    accounts_user_id: Enum.random(1..10) # Pick random user for post to belong to
  })
end