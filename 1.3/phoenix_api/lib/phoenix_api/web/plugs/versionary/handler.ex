defmodule Versionary.Plug.Handler do
  @moduledoc """
  Provides the ability to specify how to finish processing a request when
  version validation fails.

  Typically a handler will finish the request by responding with a 400 level
  HTTP status code. For example, `Versionary.Plug.ErrorHandler` responds to the
  request with a `406` status code and sets the body to `Not Acceptable`.

  To create your own handler override the `call/1` function of this behavior.
  A `Plug.Conn` will be provided as the only argument.

  Keep in mind that `Versionary.Plug.EnsureVersion` will halt the request
  before calling a handler. Once a handler processes the error the plug request
  lifecycle will finish.

  ## Example

  ```
  defmodule MyAPI.MyErrorHandler do
    @behaviour Versionary.Plug.Handler

    def call(conn) do
      body = %{
        error: %{
          description: "Not Acceptable"
        }
      }

      conn
      |> send_resp(406, Poison.encode!(body))
    end
  end

  defmodule MyAPI.MyController do
    plug Versionary.Plug.VerifyHeader, versions: ["application/vnd.app.v1+json"]

    plug Versionary.Plug.EnsureVersion, handler: MyAPI.MyErrorHandler
  end
  ```
  """

  @callback call(Plug.Conn.t()) :: Plug.Conn.t()
end
