defmodule PhoenixMl.PythonHelper do
  @moduledoc false

  def py_instance(path) when is_binary(path) do
    {:ok, pid} = :python.start([{:python_path, to_charlist(path)}])
    pid
  end

  def py_call(pid, module, func, args \\ []) do
    pid
    |> :python.call(module, func, args)
  end

  def py_stop(pid) do
    :python.stop(pid)
  end
end
