defmodule Pento.Survey.Rating.Query do
  import Ecto.Query
  alias Pento.Survey.Rating

  def base, do: Rating

  def preload_user(user) do
    base()
    |> for_user(user)
  end

  def for_user(query, user) do
    from q in query, where: q.user_id == ^user.id
  end
end
