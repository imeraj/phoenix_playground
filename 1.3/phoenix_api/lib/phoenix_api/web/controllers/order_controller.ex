defmodule PhoenixApi.Web.OrderController do
  use PhoenixApi.Web, :controller

  alias PhoenixApi.Sales
  alias PhoenixApi.Sales.Order
  alias PhoenixApi.EventDispatcher

  action_fallback(PhoenixApi.Web.FallbackController)

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [handler: PhoenixApi.Web.FallbackController]
    when action in [:create, :show]
  )

  plug(:scrub_params, "order" when action in [:create])

  def create(%{assigns: %{version: :v1}} = conn, %{"order" => order_params}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Order{} = order} <-
           Sales.create_order(Map.put_new(order_params, "accounts_users_id", user.id)) do
      EventDispatcher.broadcast(:notification, %{
        event: "order_confirmation",
        payload: %{user: user, order: order}
      })

      conn
      |> put_status(:created)
      |> put_resp_header("location", order_path(conn, :show, order))
      |> render("show.v1.json", order: order)
    end
  end

  def show(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    order = Sales.get_order!(id)
    PhoenixETag.render_if_stale(conn, "show.v1.json", order: order)
  end
end
