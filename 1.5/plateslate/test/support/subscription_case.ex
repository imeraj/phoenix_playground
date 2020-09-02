defmodule PlateslateWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use PlateslateWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: PlateslateWeb.Schema

      setup do
        Plateslate.Seeds.run()
        {:ok, socket} = Phoenix.ChannelTest.connect(PlateslateWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)
        {:ok, socket: socket}
      end

      import unquote(__MODULE__), only: [menu_item: 1]
    end
  end

  # handy function for grabbing a fixture
  def menu_item(name) do
    Plateslate.Repo.get_by!(Plateslate.Menu.Item, name: name)
  end
end
