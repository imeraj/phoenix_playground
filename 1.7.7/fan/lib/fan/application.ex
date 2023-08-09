defmodule Fan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FanWeb.Telemetry,
      # Start the Ecto repository
      Fan.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fan.PubSub},
      # Start Finch
      {Finch, name: Fan.Finch},
      # Start the Endpoint (http/https)
      FanWeb.Endpoint
      # Start a worker by calling: Fan.Worker.start_link(arg)
      # {Fan.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
