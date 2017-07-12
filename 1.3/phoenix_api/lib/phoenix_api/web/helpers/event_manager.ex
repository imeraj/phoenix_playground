defmodule PhoenixApi.EventManager do
	@name :event_manager

	alias PhoenixApi.Email
  alias PhoenixApi.Mailer

	def child_spec, do: Supervisor.Spec.worker(GenEvent, [[name: @name]])
	def init(pid), do:  {:ok, pid}

	def register(handler, args), do: GenEvent.add_handler(@name, handler, args)
	def notify(event, payload), do: GenEvent.notify(@name, {event, payload})

	def register_event_manager() do
	  GenEvent.add_handler(@name, __MODULE__, NULL)
	end

	def handle_event({:order_confirmation, payload}, state) do
	  Email.order_confirmation_html_email(payload.user.email, payload.order)
    |> Mailer.deliver_later()
	  {:ok, state}
	end

	def handle_event(_, state) do
	  {:ok, state}
	end
end
