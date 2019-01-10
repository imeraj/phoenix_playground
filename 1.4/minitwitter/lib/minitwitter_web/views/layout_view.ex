defmodule MinitwitterWeb.LayoutView do
  use MinitwitterWeb, :view

  def title("home.html", _assigns), do: "Home"
  def title("help.html", _assigns), do: "Help"
end
