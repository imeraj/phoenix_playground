defmodule RumblWeb.TestHelpers do
  alias(Rumbl.Repo)
  alias Rumbl.Accounts.User
  alias Rumbl.Videos.{Video, Category}

  @create_attrs %{name: "Meraj", username: "meraj", password: "password"}

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(@create_attrs, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos)
    |> Video.changeset(attrs)
    |> Repo.insert!()
  end
end
