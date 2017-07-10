defmodule PhoenixApi.Web.Router do
  use PhoenixApi.Web, :router

  pipeline :api do
    plug Versionary.Plug.VerifyHeader, accepts: [:v1, :v2]
    plug Versionary.Plug.EnsureVersion, handler: Versionary.Plug.PhoenixErrorHandler
		plug :accepts, ["json"]
  end

	pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", PhoenixApi.Web do
    pipe_through [:api, :api_auth]

		post "/signup", UserController, :create
    post "/login",  SessionController, :create
    delete "/logout", SessionController, :destory

    resources "/users", UserController, only: [:show, :index, :delete, :update]
    resources "/products", ProductController, only: [:create, :index, :delete, :update]
    resources "/orders", OrderController, only: [:create, :show]
  end
end



