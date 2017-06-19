defmodule Rumbl.TestHelpers do
  alias Rumbl.Repo

  def insert_user(attrs \\ %{}) do
    params = Map.merge(%{name: "Meraj", username: "meraj", password: "secret"}, attrs)

    %Rumbl.User{}
    |> Rumbl.User.registration_changeset(params)
    |> Rumbl.Repo.insert!()
  end

  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Rumbl.Repo.insert!()
  end

end
