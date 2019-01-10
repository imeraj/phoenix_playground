defmodule Minitwitter.Repo do
  use Ecto.Repo,
    otp_app: :minitwitter,
    adapter: Ecto.Adapters.MySQL
end
