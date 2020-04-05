defmodule HelloSocketsWeb.PingChannel do
  use Phoenix.Channel
  require Logger

  intercept ["request_ping"]

  def join(
    "ping:" <> req_user_id,
    _payload,
    socket = %{assigns: %{user_id: user_id}}) do
    if req_user_id == to_string(user_id) do
      {:ok, socket}
    else
      Logger.error("#{__MODULE__} failed #{req_user_id} != #{user_id}}}")
      {:error, %{resaon: "unauthorized"}}
    end
  end


  def handle_in("ping", %{"ack_phrase" => ack_phrase}, socket) do
    {:reply, {:ok, %{ping: ack_phrase}}, socket}
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  def handle_in("pong", _payload, socket) do
    {:stop, :shutdown, {:ok, %{msg: "shutting down"}}, socket}
  end

  def handle_out("request_ping", payload, socket) do
    push(socket, "send_ping", Map.put(payload, "from_node", Node.self()))
    {:noreply, socket}
  end
end
