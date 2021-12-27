defmodule Pento.Promo.Recipient do
  defstruct [:first_name, :email]
  @types %{first_name: :string, email: :string}

  alias Pento.Promo.Recipient

  import Ecto.Changeset

  def changeset(%Recipient{} = recipient, attrs) do
    {recipient, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
