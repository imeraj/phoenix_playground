defmodule FrescoWeb.Plugs.Subdomain do
  @behaviour Plug

  import Plug.Conn, only: [put_private: 3, halt: 1]

  def init(opts), do: Map.merge(opts, %{root_host: FrescoWeb.Endpoint.config(:url)[:host]})

  def call(
        %Plug.Conn{host: host} = conn,
        %{root_host: root_host, subdomain_router: router} = _opts
      ) do
    case extract_subdomain(host, root_host) do
      subdomain when byte_size(subdomain) > 0 ->
        put_private(conn, :subdomain, subdomain)
        |> router.call(router.init({}))
        |> halt()

      _ ->
        conn
    end
  end

  defp extract_subdomain(host, root_host), do: String.replace(host, ~r/.?#{root_host}/, "")
end
