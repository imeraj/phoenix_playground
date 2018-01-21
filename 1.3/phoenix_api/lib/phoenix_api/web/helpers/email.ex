defmodule PhoenixApi.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: PhoenixApi.EmailView

  def order_confirmation_text_email(email_address, order) do
    new_email()
    |> to(email_address)
    |> from("no-reply@phoenixapi.org")
    |> subject("Order Confirmation")
    |> put_text_layout({PhoenixApi.Web.LayoutView, "email.text"})
    |> render("email/order_confirmation.text", email: email_address, order: order)
  end

  def order_confirmation_html_email(email_address, order) do
    new_email()
    |> to(email_address)
    |> from("no-reply@phoenixapi.org")
    |> subject("Order Confirmation!")
    |> put_html_layout({PhoenixApi.Web.LayoutView, "email.html"})
    |> render("email/order_confirmation.html", email_address: email_address, order: order)
  end
end
