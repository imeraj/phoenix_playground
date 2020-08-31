defmodule PlateslateWeb.Graphql.Scalars.Decimal do
  use Absinthe.Schema.Notation

  scalar :decimal do
    parse(fn
      %{value: value}, _ ->
        Decimal.parse(value)

      _, _ ->
        :error
    end)

    serialize(&to_string/1)
  end
end
