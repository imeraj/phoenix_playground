defmodule HelloWorld.Web.HelloController do
  use HelloWorld.Web, :controller

  def world(conn, %{"name" => name}) do
    render conn, "world.html", name: name
  end
end
