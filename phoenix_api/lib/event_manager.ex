defmodule PhoenixApi.EventManager do
  @name :event_manager

  def child_spec, do: Supervisor.Spec.worker(GenEvent, [[name: @name]])

  def init(pid), do: {:ok, pid}

  def notify(event, payload), do: GenEvent.notify(@name, {event, payload})

  def register(handler, args), do: GenEvent.add_handler(@name, handler, args)

  def register_event_manager() do
    GenEvent.add_handler(@name, __MODULE__, nil)
  end

  def handle_event(event, parent) do
    case event do
      {:order_confirmation, payload} ->
        PhoenixApi.Email.order_confirmation_html_email(payload.user.email, payload.order)
        |> PhoenixApi.Mailer.deliver_later
     _ -> "Unknown event"
    end
    {:ok, parent}
  end
end
