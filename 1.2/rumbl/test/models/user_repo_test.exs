defmodule Rumbl.UserRepoTest do
  use Rumbl.ModelCase

	alias Rumbl.TestHelpers
  alias Rumbl.User

  @valid_attrs %{name: "A User", username: "eva", password: "secret"}
  @invalid_attrs %{}

	test "converts unique_constraint on username to error" do
	  TestHelpers.insert_user(%{username: "eva"})
	  changeset = User.changeset(%User{}, @valid_attrs)

		assert {:error, changeset} = Rumbl.Repo.insert(changeset)
		assert changeset.errors[:username] == {"has already been taken", []}
	end

end