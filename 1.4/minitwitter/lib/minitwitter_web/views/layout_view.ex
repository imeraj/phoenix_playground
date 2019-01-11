defmodule MinitwitterWeb.LayoutView do
  use MinitwitterWeb, :view

  def full_title(template, _assigns), do:
    title(template) <> " | Minitwitter Phoenix App"

    defp title("home.html"), do: "Home"
    defp title("contact.html"), do: "Contact"
    defp title(_), do: "Minitwitter Phoenix App"    
end
