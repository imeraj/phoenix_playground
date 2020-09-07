defmodule Factory do
  def create_user(role) do
    int = :erlang.unique_integer([:positive, :monotonic])

    params = %{
      name: "Person #{int}",
      email: "fake-#{int}@example.com",
      password: "super-secret",
      role: role
    }

    %Plateslate.Accounts.User{}
    |> Plateslate.Accounts.User.changeset(params)
    |> Plateslate.Repo.insert!()
  end
end
