defmodule Fresco.Repo do
  use Ecto.Repo,
    otp_app: :fresco,
    adapter: Ecto.Adapters.Postgres
end
