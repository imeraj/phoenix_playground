defmodule CmsContextWeb.Router do
  use CmsContextWeb, :router
  import Authentication

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

  scope "/", CmsContextWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/users", UserController)
    resources("/sessions", SessionController, only: [:new, :create, :delete], singleton: true)
  end

  scope "/cms", CmsContextWeb.CMS, as: :cms do
    pipe_through([:browser, :authenticate_user])

    resources("/pages", PageController)
  end
end
