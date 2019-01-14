defmodule Minitwitter.Repo do
  use Ecto.Repo,
    otp_app: :minitwitter,
    adapter: Ecto.Adapters.MySQL

  use Scrivener, page_size: 10
end
