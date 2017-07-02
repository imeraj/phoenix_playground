defmodule PhoenixApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixApi.Accounts.User

  schema "accounts_users" do
    field :email, :string
    field :encrypted_password, :string
    field :name, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email, downcase: true)
    |> validate_length(:name, min: 3, max: 10)
    |> validate_length(:password, min: 5, max: 10)
  end

	@doc false
	def registraion_changeset(%User{} = user, attrs) do
	  user
	  |> changeset(attrs)
	  |> put_pass_hash()
	end

  @doc false
  def update_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_length(:name, min: 3, max: 10)
    |> validate_length(:password, min: 5, max: 10)
    |> put_pass_hash()
  end

	defp put_pass_hash(changeset) do
		IO.inspect changeset
	  case changeset do
	    %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
	      put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
	    _ ->
	      changeset
	  end
	end

end

