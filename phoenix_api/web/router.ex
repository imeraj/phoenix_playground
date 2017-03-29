defmodule PhoenixApi.Router do
  use PhoenixApi.Web, :router

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

  scope "/api", PhoenixApi.Api do
    pipe_through :api

    scope "/v1", V1 do
      resources "/users", UserController, only: [:show, :create, :index]
    end

    scope "/v2", V2 do
      resources "/users", UserController, only: [:show, :create, :index]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixApi do
  #   pipe_through :api
  # end
end
