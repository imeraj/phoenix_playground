defmodule HelloWorld.Web.Router do
  use HelloWorld.Web, :router

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

  scope "/", HelloWorld.Web do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/hello/:name", HelloController, :world)
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWorld.Web do
  #   pipe_through :api
  # end
end
