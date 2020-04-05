defmodule HelloSocketsWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  @one_day 86400

  ## Channels
  channel "ping:*", HelloSocketsWeb.PingChannel
  channel "wild:*", HelloSocketsWeb.WildcardChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case verify(socket, token) do
      {:ok, user_id} ->
        socket = assign(socket, :user_id, user_id)
        {:ok, socket}

      {:error, err} ->
        Logger.info("#{__MODULE__} connect error #{inspect(err)}}")
        :error
    end
  end

  def connect(_, _socket) do
    Logger.error("#{__MODULE__} connect error missing params")
    :error
  end

  defp verify(socket, token) do
    salt =  Application.get_env(:hello_sockets, HelloSocketsWeb.Endpoint)[:secret_key_base]
    Phoenix.Token.verify(
      socket,
      salt,
      token,
      max_age: @one_day
    )
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     HelloSocketsWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket = %{assigns: %{user_id: user_id}}), do: "user_socket:#{user_id}}"
end
