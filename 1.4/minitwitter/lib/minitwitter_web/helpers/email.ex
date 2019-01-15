defmodule MinitwitterWeb.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: MinitwitterWeb.EmailView

  def account_activation_text_email(conn, user) do
    new_email()
    |> to(user.email)
    |> from("no-reply@minitwitter.org")
    |> subject("Account activation")
    |> put_text_layout({MinitwitterWeb.LayoutView, "email.text"})
    |> render("account_activation.text", conn: conn, email: user.email, user: user)
  end

  def account_activation_html_email(conn, user) do
    new_email()
    |> to(user.email)
    |> from("no-reply@minitwitter.org")
    |> subject("Account activation")
    |> put_html_layout({MinitwitterWeb.LayoutView, "email.html"})
    |> render("account_activation.html", conn: conn, email: user.email, user: user)
  end
end
