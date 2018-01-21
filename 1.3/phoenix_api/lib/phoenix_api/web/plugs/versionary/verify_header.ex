defmodule Versionary.Plug.VerifyHeader do
  @moduledoc """
  Use this plug to verify a version string in the header.

  ## Example

  ```
  plug Versionary.Plug.VerifyHeader, versions: ["application/vnd.app.v1+json"]
  ```

  If multiple versions are passed to this plug and at least one matches the
  version will be considered valid.

  ## Example

  ```
  plug Versionary.Plug.VerifyHeader, versions: ["application/vnd.app.v1+json",
                                                "application/vnd.app.v2+json"]
  ```

  It's also possible to verify versions against configured mime types. If
  multiple mime types are passed and at least one matches the version will be
  considered valid.

  ## Example

  ```
  config :mime, :types, %{
    "application/vnd.app.v1+json" => [:v1]
  }
  ```

  ```
  plug Versionary.Plug.VerifyHeader, accepts: [:v1]
  ```

  By default, this plug will look at the `Accept` header for the version string
  to verify against. If you'd like to verify against another header specify the
  header you'd like to verify against in the `header` option.

  ## Example

  ```
  plug Versionary.Plug.VerifyHeader, header: "accept",
                                     versions: ["application/vnd.app.v1+json"]
  ```
  """

  import Plug.Conn

  @default_header_opt "accept"

  @doc false
  def init(opts) do
    %{
      accepts: opts[:accepts] || [],
      header: opts[:header] || @default_header_opt,
      versions: opts[:versions] || []
    }
  end

  @doc false
  def call(conn, opts) do
    conn
    |> verify_version(opts)
  end

  # private

  defp get_all_versions(opts) do
    opts[:versions] ++ get_mime_versions(opts)
  end

  defp get_mime_versions(%{accepts: accepts}), do: get_mime_versions(accepts)
  defp get_mime_versions([h | t]), do: [Plug.MIME.type(h)] ++ get_mime_versions(t)
  defp get_mime_versions([]), do: []
  defp get_mime_versions(nil), do: []

  def get_version(conn, opts) do
    case get_req_header(conn, opts[:header]) do
      [] -> nil
      [version] -> version
    end
  end

  defp verify_version(conn, opts) do
    verified = Enum.member?(get_all_versions(opts), get_version(conn, opts))

    conn = assign(conn, :version, get_version(conn, opts))
    put_private(conn, :version_verified, verified)
  end
end
