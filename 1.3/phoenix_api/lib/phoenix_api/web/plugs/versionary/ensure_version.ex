defmodule Versionary.Plug.EnsureVersion do
  @moduledoc """
  This plug ensures that a valid version was provided and has been verified
  on the request.

  If the version provided is not valid then the request will be halted and the
  module provied to `handler` will be called. From there the handler can decide
  how to finish the request.

  If a handler isn't provided `Versionary.Plug.ErrorHandler.call/1` will be used
  as a default.

  ## Example

  ```
  plug Versionary.Plug.EnsureVersion, handler: SomeModule
  ```
  """

  require Logger

  import Plug.Conn

	@versions Application.get_env(:mime, :types)

  @doc false
  def init(opts \\ []) do
    %{
      handler: opts[:handler] || Versionary.Plug.ErrorHandler
    }
  end

  @doc false
  def call(conn, opts) do
    case conn.private[:version_verified] do
      true ->
        {:ok, [version]} = Map.fetch(@versions, conn.assigns[:version])
        conn =
          conn
          |> Plug.Conn.put_req_header("accept", "application/json")
					|> assign(:version, version)
      false ->
        handle_error(conn, opts)
      nil ->
        Logger.warn("Version has not been verified. Make sure Versionary.Plug.VerifyHeader has been called.")
        conn
    end
  end

  # private

  defp handle_error(conn, opts) do
    handler_opt = opts[:handler]

    conn = conn |> halt

    apply(handler_opt, :call, [conn])
  end
end
