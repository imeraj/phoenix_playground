defmodule BlogAppGql.Web.Blog.PostResolver do
  alias BlogAppGql.Blog

  def all(_args, _info) do
    {:ok, Blog.list_posts()}
  end
end