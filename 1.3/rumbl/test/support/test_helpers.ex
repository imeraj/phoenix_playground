defmodule RumblWeb.TestHelpers do
  alias(Rumbl.Repo)
  alias Rumbl.Accounts.User

  @create_attrs %{name: "Meraj", username: "meraj", password: "password"}

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(@create_attrs, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end
end
