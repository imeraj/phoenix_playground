defmodule PhoenixApi.Web.Router do
  use PhoenixApi.Web, :router

  pipeline :api do
    plug Versionary.Plug.VerifyHeader, accepts: [:v1, :v2]
    plug Versionary.Plug.EnsureVersion, handler: Versionary.Plug.PhoenixErrorHandler
  end

  scope "/api", PhoenixApi.Web do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end
end
