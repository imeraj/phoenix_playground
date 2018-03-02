defmodule BlogAppGql.Web.Schema do
  use Absinthe.Schema
  import_types(BlogAppGql.Web.Schema.Types)

  query do
    field :blog_posts, type: list_of(:blog_post) do
      resolve(&BlogAppGql.Blog.PostResolver.all/2)
    end

    field :blog_post, type: :blog_post do
      arg(:id, non_null(:id))
      resolve(&BlogAppGql.Blog.PostResolver.find/2)
    end

    field :accounts_users, type: list_of(:accounts_user) do
      resolve(&BlogAppGql.Accounts.UserResolver.all/2)
    end

    field :accounts_user, type: :accounts_user do
      arg(:email, non_null(:string))
      resolve(&BlogAppGql.Accounts.UserResolver.find/2)
    end

    field :login, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&BlogAppGql.Accounts.UserResolver.login/2)
    end

    mutation do
      field :create_post, type: :blog_post do
        arg(:title, non_null(:string))
        arg(:body, non_null(:string))
        arg(:accounts_user_id, non_null(:id))

        resolve(&BlogAppGql.Blog.PostResolver.create/2)
      end

      field :create_user, type: :accounts_user do
	      arg(:name, non_null(:string))
	      arg(:email, non_null(:string))
	      arg(:password, non_null(:string))

	      resolve(&BlogAppGql.Accounts.UserResolver.create/2)
      end

      field :update_post, type: :blog_post do
        arg(:id, non_null(:id))
        arg(:post, :update_post_params)

        resolve(&BlogAppGql.Blog.PostResolver.update/2)
      end

      field :delete_post, type: :blog_post do
        arg(:id, non_null(:id))
        resolve(&BlogAppGql.Blog.PostResolver.delete/2)
      end

      field :sign_out, type: :accounts_user do
	      arg(:id, non_null(:id))
	      resolve(&BlogAppGql.Accounts.UserResolver.logout/2)
      end
    end
  end
end
