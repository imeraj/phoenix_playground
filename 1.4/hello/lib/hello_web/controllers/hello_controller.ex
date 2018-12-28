defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  def world(conn, %{"name" => name}) do
    render(conn, "world.html", name: name)
  end
end
