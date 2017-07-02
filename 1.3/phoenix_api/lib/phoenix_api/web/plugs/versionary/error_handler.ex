defmodule Versionary.Plug.ErrorHandler do
  @moduledoc """
  A default error handler that can be used for failed version verification.

  When called this handler will respond to the request with a
  `406 Not Acceptable` HTTP status.
  """

  @behaviour Versionary.Plug.Handler

  import Plug.Conn

  @doc false
  def call(conn) do
    conn
    |> send_resp(406, "Not Acceptable")
  end
end
