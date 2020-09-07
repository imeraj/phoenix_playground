defmodule PlateslateWeb.Authentication do
  @user_salt "user salt"
  @max_age 365 * 24 * 3600

  def sign(data) do
    Phoenix.Token.sign(PlateslateWeb.Endpoint, @user_salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(PlateslateWeb.Endpoint, @user_salt, token, max_age: @max_age)
  end
end
