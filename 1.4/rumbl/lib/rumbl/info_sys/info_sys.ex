defmodule Rumbl.InfoSys do
    alias Rumbl.InfoSys

    alias Rumbl.InfoSys.Cache

    @backends [InfoSys.Wolfram]

    defmodule Result do
      defstruct score: 0, text: nil, url: nil, backend: nil
    end

    def compute(query, opts \\ []) do
      timeout = opts[:timeout] || 10_000
      opts = Keyword.put_new(opts, :limit, 10)
      backends = opts[:backends] || @backends

      {uncached_backends, cached_results} =
        fetch_cached_results(backends, query, opts)

      uncached_backends
      |> Enum.map(&async_query(&1, query, opts))
      |> Task.yield_many(timeout)
      |> Enum.map(fn {task, res} -> res || Task.shutdown(task, :brutal_kill) end)
      |> Enum.flat_map(fn
        {:ok, results} -> results
        _ -> []
      end)
      |> write_results_to_cache(query, opts)
      |> Kernel.++(cached_results)
      |> Enum.sort(&(&1.score >= &2.score))
      |> Enum.take(opts[:limit])
    end

    defp async_query(backend, query, opts) do
      Task.Supervisor.async_nolink(InfoSys.TaskSupervisor, backend,
          :compute, [query, opts], shutdown: :brutal_kill)
    end

    defp fetch_cached_results(backends, query, opts) do
      {uncached_backends, results} =
        Enum.reduce(
                   backends,
                   {[], []},
                   fn backend, {uncached_backends, acc_results} ->
                      case Cache.fetch({backend, query, opts[:limit]}) do
                        {:ok, results} -> {uncached_backends, [results | acc_results]}
                        :error -> {[backend.name() | uncached_backends], acc_results}
                      end
                   end)
      {uncached_backends, List.flatten(results)}
    end

    defp write_results_to_cache(results, query, opts) do
      Enum.map(results, fn %Result{backend: backend} = result ->
        :ok = Cache.put({backend.name(), query, opts[:limit]}, result)
        result
      end)
    end
end
