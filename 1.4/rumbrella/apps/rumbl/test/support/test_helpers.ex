defmodule Rumbl.TestHelpers do
  alias Rumbl.{
      Accounts,
      Multimedia
    }

  def user_fixture(attrs \\ %{}) do
    name = Faker.Name.name()

    {:ok, user} =
      attrs
      |> Enum.into(%{
            name: name,
            username: first_name(name),
            credential: %{
                email: attrs[:email] || Faker.Internet.email(),
                password: attrs[:password] || "phoenix"
            }
      })
      |> Accounts.register_user()
    user
  end

  def video_fixture(%Rumbl.Accounts.User{} = user, attrs \\ %{}) do
    category = Multimedia.create_category("Action")

    attrs =
      Enum.into(attrs, %{
          url: "www.youtube.com",
          title: "A title",
          description: "Youtube",
          category_id: category.id
       })
    {:ok, video} = Multimedia.create_video(user, attrs)
    video
  end

  defp first_name(name) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end