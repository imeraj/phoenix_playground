defmodule FrescoWeb.SubdomainRouter do
  use FrescoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FrescoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrescoWeb.Subdomain do
    pipe_through :browser

    get "/", PageController, :index

    get "/products", ProductsController, :index
  end
end
