defmodule PhoenixApi.Repo do
  use Ecto.Repo, otp_app: :phoenix_api
  use Scrivener, page_size: 10
end
