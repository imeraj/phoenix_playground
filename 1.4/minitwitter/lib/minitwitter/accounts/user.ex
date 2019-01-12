defmodule Minitwitter.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :email, :string

    timestamps()
  end

  @email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @email_regex)
    |> downcase_email()
    |> unique_constraint(:email)
  end

  defp downcase_email(changeset) do
    case fetch_change(changeset, :email) do
      {:ok, email} -> put_change(changeset, :email, String.downcase(email))
      :error -> changeset
    end
  end
end
