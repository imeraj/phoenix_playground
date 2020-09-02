defmodule Graphql.Resolvers.Ordering do
  alias Plateslate.Ordering

  def order_place(_, %{input: order_place_input}, _) do
    case Ordering.create_order(order_place_input) do
      {:ok, order} ->
        Absinthe.Subscription.publish(PlateslateWeb.Endpoint, order, new_order: "*")
        {:ok, order}

      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  def ready_order(_, %{id: id}, _) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "ready"}) do
      {:ok, order}
    else
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  def complete_order(_, %{id: id}, _) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "complete"}) do
      {:ok, order}
    else
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
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
