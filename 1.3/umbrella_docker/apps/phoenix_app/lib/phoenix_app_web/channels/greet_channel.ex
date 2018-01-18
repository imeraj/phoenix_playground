defmodule PhoenixApp.GreetChannel do
  use Phoenix.Channel

  def join("room:greet", _message, socket) do
    {:ok, socket}
  end

  def greet("room:greet", name, _socket) do
    greet = Greeter.hello(name)
    {:ok, greet}
  end

  def handle_in("greet", %{"name" => name}, socket) do
    broadcast! socket, "greet", %{msg: Greeter.hello(name)}
    {:noreply, socket}
  end
end
