defmodule Rumbl.Repo do
  use Ecto.Repo,
    otp_app: :rumbl,
    adapter: Ecto.Adapters.MySQL
end
