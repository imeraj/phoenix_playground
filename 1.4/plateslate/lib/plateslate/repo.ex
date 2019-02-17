defmodule Plateslate.Repo do
  use Ecto.Repo,
    otp_app: :plateslate,
    adapter: Ecto.Adapters.MySQL
end
