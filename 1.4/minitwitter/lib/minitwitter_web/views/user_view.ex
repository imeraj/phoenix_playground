defmodule MinitwitterWeb.UserView do
  use MinitwitterWeb, :view
  use Timex

  alias Minitwitter.Accounts

  @gravatar_url "https://secure.gravatar.com/avatar/"

  def button_label("new.html", _assigns), do: "Create my account"
  def button_label("edit.html", _assigns), do: "Save changes"
  def button_label(_, _), do: ""

  def gravatar_for(user, size \\ 80) do
    gravatar_id =
      :crypto.hash(:md5, String.downcase(user.email))
      |> Base.encode16(case: :lower)

    gravatar_url = @gravatar_url <> gravatar_id <> "?s=#{size}"
    img_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
