defmodule MinitwitterWeb.UserView do
  use MinitwitterWeb, :view

  @gravatar_url "https://secure.gravatar.com/avatar/"

  def gravatar_for(user, size \\ 80) do
    gravatar_id =
      :crypto.hash(:md5, String.downcase(user.email))
      |> Base.encode16(case: :lower)

    gravatar_url = @gravatar_url <> gravatar_id <> "?s=#{size}"
    img_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
