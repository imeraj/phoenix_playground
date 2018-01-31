defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Rumbl.Auth.AuthAccessPipeline)
  end

  scope "/", RumblWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/users", UserController, only: [:new, :create])
    resources("/sessions", SessionController, only: [:new, :create])
  end

  scope "/", RumblWeb do
    pipe_through([:browser, :auth])

    resources("/users", UserController, only: [:index, :show])
    resources("/videos", VideoController)
    resources("/sessions", SessionController, only: [:delete])
    get("/watch/:id", WatchController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", RumblWeb do
  #   pipe_through :api
  # end
end
