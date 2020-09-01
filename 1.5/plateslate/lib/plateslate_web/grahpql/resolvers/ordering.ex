defmodule Graphql.Resolvers.Ordering do
  alias Plateslate.Ordering

  def order_place(_, %{input: order_place_input}, _) do
    case Ordering.create_order(order_place_input) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}

      {:ok, menu_item} ->
        {:ok, menu_item}
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn
      {key, value} ->
        %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error()) :: String.t()
  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
