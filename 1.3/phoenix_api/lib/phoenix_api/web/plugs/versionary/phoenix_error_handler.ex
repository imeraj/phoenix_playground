defmodule Versionary.Plug.PhoenixErrorHandler do
  @moduledoc """
  An error handler for usage with Phoenix.

  When called this handler raise a `Phoenix.NotAcceptableError` triggering the
  `406.json` error view.
  """

  @behaviour Versionary.Plug.Handler

  def call(_conn) do
    verify_phoenix_dep()

    raise Phoenix.NotAcceptableError, message: "no supported media type in accept header"
  end

  # private

  defp verify_phoenix_dep do
    unless Code.ensure_loaded?(Phoenix) do
      raise """
      You tried to use Versionary.Plug.PhoenixErrorHandler, but the Phoenix
      module is not loaded. Please add phoenix to your dependencies.
      """
    end
  end
end
