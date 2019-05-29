defmodule PhoenixMl.IrisParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          sepal_length: float,
          sepal_width: float,
          petal_length: float,
          petal_width: float
        }
  defstruct [:sepal_length, :sepal_width, :petal_length, :petal_width]

  field(:sepal_length, 1, type: :float)
  field(:sepal_width, 2, type: :float)
  field(:petal_length, 3, type: :float)
  field(:petal_width, 4, type: :float)
end
