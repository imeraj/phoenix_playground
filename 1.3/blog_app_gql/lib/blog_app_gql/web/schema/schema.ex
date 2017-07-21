defmodule BlogAppGql.Web.Schema do
  use Absinthe.Schema
  import_types BlogAppGql.Web.Schema.Types

  query do
    field :blog_posts, list_of(:blog_post) do
      resolve &BlogAppGql.Web.Blog.PostResolver.all/2
    end

    field :accounts_users, list_of(:accounts_user) do
      resolve &BlogAppGql.Web.Accounts.UserResolver.all/2
    end
  end
end