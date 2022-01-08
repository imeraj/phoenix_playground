defmodule Pento.Survey.Demographic.Query do
  import Ecto.Query
  alias Pento.Survey.Demographic

  def base, do: Demographic

  def for_user(query \\ base(), user) do
    from q in query, where: q.user_id == ^user.id
  end
end
