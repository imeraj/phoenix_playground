defmodule BlogAppGql.Web.Schema do
  use Absinthe.Schema
  import_types BlogAppGql.Web.Schema.Types

	input_object :update_post_params do
    field :title, :string
    field :body, :string
    field :accounts_user_id, :id
	end

  query do
    field :blog_posts, list_of(:blog_post) do
      resolve &BlogAppGql.Web.Blog.PostResolver.all/2
    end

    field :blog_post, type: :blog_post do
      arg :id, non_null(:id)
      resolve &BlogAppGql.Web.Blog.PostResolver.find/2
    end

    field :accounts_users, list_of(:accounts_user) do
      resolve &BlogAppGql.Web.Accounts.UserResolver.all/2
    end

    field :accounts_user, :accounts_user do
      arg :email, non_null(:string)
      resolve &BlogAppGql.Web.Accounts.UserResolver.find/2
    end

		mutation do
			field :create_post, type: :blog_post do
        arg :title, non_null(:string)
        arg :body, non_null(:string)
        arg :accounts_user_id, non_null(:id)

        resolve &BlogAppGql.Web.Blog.PostResolver.create/2
      end

      field :update_post, type: :blog_post do
          arg :id, non_null(:id)
          arg :post, :update_post_params

          resolve&BlogAppGql.Web.Blog.PostResolver.update/2
      end

			field :delete_post, type: :blog_post do
        arg :id, non_null(:id)
        resolve &BlogAppGql.Web.Blog.PostResolver.delete/2
      end
    end
  end
end
