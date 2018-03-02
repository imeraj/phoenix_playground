defmodule BlogAppGql.Web.Router do
  use BlogAppGql.Web, :router

  pipeline :graphql do
	  plug BlogAppGql.Context
  end

  scope "/api" do
    pipe_through(:graphql)

    forward("/", Absinthe.Plug, schema: BlogAppGql.Web.Schema)
    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: BlogAppGql.Web.Schema)
  end
end
