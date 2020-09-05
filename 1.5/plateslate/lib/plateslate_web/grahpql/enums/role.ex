defmodule PlateslateWeb.Graphql.Enums.Role do
  use Absinthe.Schema.Notation

  enum :role do
    value(:customer, as: "customer")
    value(:employee, as: "employee")
  end
end
