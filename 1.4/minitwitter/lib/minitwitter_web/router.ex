defmodule MinitwitterWeb.Router do
  use MinitwitterWeb, :router

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

  scope "/", MinitwitterWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/home", PageController, :home
    get "/help", PageController, :help
  end

  # Other scopes may use custom stacks.
  # scope "/api", MinitwitterWeb do
  #   pipe_through :api
  # end
end
