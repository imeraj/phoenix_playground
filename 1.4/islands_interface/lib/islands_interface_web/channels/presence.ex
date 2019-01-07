defmodule IslandsInterfaceWeb.Presence do
    use Phoenix.Presence, otp_app: :islands_interface,
                    pubsub_server:  IslandsInterface.PubSub
end
