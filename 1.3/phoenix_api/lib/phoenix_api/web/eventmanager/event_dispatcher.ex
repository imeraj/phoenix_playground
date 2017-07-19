defmodule PhoenixApi.EventDispatcher do
  use GenServer
	@name :pubsub_elixir_registry

	def start_link(topic, otp_opts \\ []) do
	  GenServer.start_link(__MODULE__, topic, otp_opts)
	end

	def subscribe_to_topic(topic) when is_atom(topic) do
		start_link(:notification)
	end

	def broadcast(topic, message) do
	  Registry.dispatch(@name, topic, fn entries ->
	    for {pid, _} <- entries, do: send(pid, {:broadcast, message})
	   end)
	end

	def init(topic) do
	  Registry.register(@name, topic, [])
	  {:ok, []}
	end

	def handle_info({:broadcast, message}, state) do
		case message.event do
			"order_confirmation" ->
				PhoenixApi.EventHandler.handle_event({:order_confirmation, message.payload})
			_ -> "Unknown event!"
		end
	  {:noreply, state}
	end
end

