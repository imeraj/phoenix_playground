defmodule PhoenixMlWeb.Router do
  use PhoenixMlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixMlWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/predict", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixMlWeb do
  #   pipe_through :api
  # end
end
