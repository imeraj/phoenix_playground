defmodule PhoenixMl.ModelPredictor do
  @moduledoc false

  alias PhoenixMl.PythonHelper, as: Helper

  @path 'lib/phoenix_ml/model/'

  def predict(args) do
    call_python(:classifier, :predict_model, args)
  end

  defp call_python(module, func, args) do
    pid = Helper.py_instance(Path.absname(@path))
    result = Helper.py_call(pid, module, func, args)

    pid
    |> Helper.py_stop()

    result
  end
end
