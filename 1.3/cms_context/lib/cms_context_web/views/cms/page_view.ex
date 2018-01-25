defmodule CmsContextWeb.CMS.PageView do
  use CmsContextWeb, :view

  def author_name(%CmsContext.CMS.Page{author: author}) do
    author.user.name
  end
end
