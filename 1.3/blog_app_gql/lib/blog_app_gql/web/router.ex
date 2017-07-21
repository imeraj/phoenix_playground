defmodule BlogAppGql.Web.Router do
  use BlogAppGql.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlogAppGql.Web do
    pipe_through :api

		resources "/users", UserController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]
  end


	forward "/graph", Absinthe.Plug,
    schema: BlogAppGql.Web.Schema

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: BlogAppGql.Web.Schema
end
