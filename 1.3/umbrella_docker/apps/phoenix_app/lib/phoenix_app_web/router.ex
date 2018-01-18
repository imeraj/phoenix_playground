defmodule PhoenixAppWeb.Router do
  use PhoenixAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authentication do
    plug BasicAuth, use_config: {:phoenix_app, :authentication}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixAppWeb do
    pipe_through [:browser, :authentication]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixAppWeb do
  #   pipe_through :api
  # end
end
