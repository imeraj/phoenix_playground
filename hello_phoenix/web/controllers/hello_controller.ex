defmodule HelloPhoenix.HelloController do
  use HelloPhoenix.Web, :controller

  def world(conn, %{"name" => name}) do
    render conn, "world.html", name: name
  end
end
