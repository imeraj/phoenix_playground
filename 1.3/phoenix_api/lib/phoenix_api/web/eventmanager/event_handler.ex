defmodule PhoenixApi.EventHandler do
  alias PhoenixApi.Email
  alias PhoenixApi.Mailer

  def handle_event({:order_confirmation, payload}) do
    Email.order_confirmation_html_email(payload.user.email, payload.order)
    |> Mailer.deliver_later()
  end

  def handle_event(_) do
    IO.puts("Unknown event!")
  end
end
