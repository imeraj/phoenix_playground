defmodule Minitwitter.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :remember_hash, :string
    field :admin, :boolean, dafault: false
    field :activation_token, :string, virtual: true
    field :activation_hash, :string
    field :activated, :boolean, default: false
    field :activated_at, :utc_datetime
    field :reset_hash, :string
    field :reset_sent_at, :utc_datetime

    has_many(:posts, Minitwitter.Microposts.Post)

    timestamps()
  end

  @email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @email_regex)
    |> validate_length(:password, min: 6, max: 32)
    |> validate_confirmation(:password)
    |> downcase_email()
    |> unique_constraint(:email)
    |> put_pass_hash()
    |> put_activation_hash()
  end

  def reset_pass_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation, :reset_hash])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6, max: 32)
    |> validate_confirmation(:password)
    |> put_pass_hash()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :email,
      :password,
      :password_confirmation,
      :remember_hash,
      :activated,
      :activated_at,
      :reset_hash,
      :reset_sent_at
    ])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @email_regex)
    |> validate_length(:password, min: 6, max: 32)
    |> validate_confirmation(:password)
    |> downcase_email()
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def new_token(size \\ 64) do
    :crypto.strong_rand_bytes(size)
    |> Base.url_encode64(padding: false)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Pbkdf2.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  defp put_activation_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        token = new_token()

        changeset
        |> put_change(:activation_token, token)
        |> put_change(:activation_hash, Comeonin.Pbkdf2.hashpwsalt(token))

      _ ->
        changeset
    end
  end

  defp downcase_email(changeset) do
    case fetch_change(changeset, :email) do
      {:ok, email} -> put_change(changeset, :email, String.downcase(email))
      :error -> changeset
    end
  end
end
