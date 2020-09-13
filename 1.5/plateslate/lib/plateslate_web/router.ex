defmodule PlateslateWeb.Router do
  use PlateslateWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PlateslateWeb.Graphql.Context
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: PlateslateWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PlateslateWeb.Schema,
      socket: PlateslateWeb.UserSocket
  end

  pipeline :admin_auth do
    plug PlateslateWeb.Plugs.AdminAuth
  end

  scope "/admin", PlateslateWeb do
    pipe_through :browser

    resources "/session", SessionController,
      only: [:new, :create, :delete],
      singleton: true
  end

  scope "/admin", PlateslateWeb do
    pipe_through [:browser, :admin_auth]

    resources "/items", ItemController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlateslateWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PlateslateWeb.Telemetry
    end
  end
end
