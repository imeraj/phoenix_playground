defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  alias Pento.Accounts

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       session_id: session["live_socket_id"],
       time: time()
     )}
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    message = "Your guess: #{guess}, Wrong. Guess again. "

    score = socket.assigns.score - 1

    {
      :noreply,
      assign(socket, message: message, score: score, time: time())
    }
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>

      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  defp time do
    DateTime.utc_now() |> to_string()
  end
end
