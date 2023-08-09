defmodule Fan.Repo do
  use Ecto.Repo,
    otp_app: :fan,
    adapter: Ecto.Adapters.Postgres
end
