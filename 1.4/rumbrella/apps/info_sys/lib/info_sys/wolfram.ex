defmodule InfoSys.Wolfram do
  alias Rumbl.InfoSys.Result

  import SweetXml

  @behaviour InfoSys.Backend

  @base "http://api.wolframalpha.com/v2/query"

  @impl true
  def name(), do: "wolfram"

  @impl true
  def compute(query_str, opts) do
    query_str
    |> fetch_xml()
    |> xpath(~x"/queryresult/pod[contains(@title, 'Result') or
                contains(@title, 'Definitions')] /subpod/plaintext/text()")
    |> build_results()
  end

  defp build_results(nil), do: []

  defp build_results(answer) do
    [%InfoSys.Result{backend: __MODULE__, score: 95, text: to_string(answer)}]
  end

  defp fetch_xml(query) do
    {:ok, {_, _, body}} = :httpc.request(String.to_charlist(url(query)))

    body
  end

  defp url(input) do
    "#{@base}?" <>
      URI.encode_query(appid: app_id(), input: input, format: "plaintext")
  end

  defp app_id, do: Application.get_env(:info_sys, :wolfram)[:app_id]
end