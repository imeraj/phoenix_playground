defmodule PlateSlateWeb.Graphql.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  def call(resolution, role) do
    with %{current_user: current_user} <- resolution.context,
         true <- correct_role?(current_user, role) do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "unauthorized"})
    end
  end

  defp correct_role?(%{}, :any), do: true
  defp correct_role?(%{role: role}, role), do: true
  defp correct_role?(_, _), do: false
end
