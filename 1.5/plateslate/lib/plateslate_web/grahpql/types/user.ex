defmodule PlateslateWeb.Graphql.Types.User do
  use Absinthe.Schema.Notation

  interface :user do
    field :id, :id
    field :email, :string
    field :name, :string

    resolve_type(fn
      %{role: "customer"}, _ ->
        :customer

      %{role: "employee"}, _ ->
        :employee
    end)
  end

  object :employee do
    interface(:user)
    field :id, :id
    field :email, :string
    field :name, :string
  end

  object :customer do
    interface(:user)
    field :id, :id
    field :email, :string
    field :name, :string
  end
end
