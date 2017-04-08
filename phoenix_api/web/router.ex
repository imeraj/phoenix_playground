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

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", PhoenixApi.Api do
    pipe_through [:api, :api_auth]

    scope "/v1", V1 do
      post "/signup", UserController, :create
      post "/login",  SessionController, :create
      delete "/logout", SessionController, :destory

      resources "/users", UserController, only: [:show, :index, :delete, :update]
      resources "/products", ProductController, except: [:new, :edit]
      resources "/orders", OrderController, only: [:create, :show]
    end

    scope "/v2", V2 do
      resources "/users", UserController, only: [:index]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixApi do
  #   pipe_through :api
  # end
end
