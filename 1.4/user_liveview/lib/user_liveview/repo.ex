defmodule UserLiveview.Repo do
  use Ecto.Repo,
    otp_app: :user_liveview,
    adapter: Ecto.Adapters.MySQL
end
