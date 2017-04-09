defmodule PhoenixApi.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: PhoenixApi.EmailView

  def order_confirmation_text_email(email_address) do
   new_email
   |> to(email_address)
   |> from("no-reply@phoenixapi.org")
   |> subject("Order Confirmation!")
   |> text_body("Your order is confirmed!")
 end
end
