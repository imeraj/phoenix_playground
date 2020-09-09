defmodule PlateslateWeb.Schema.Subscription.NewOrderTest do
  use PlateslateWeb.SubscriptionCase

  @login """
  mutation login($email: String!) {
    login(input: {
  	  email: $email,
  	  password: "super-secret"
    }) {
      token
      }
    }
  """

  @subscription """
  subscription {
    newOrder {
      customerId
    }
  }
  """

  @mutation """
  mutation ($input: OrderPlaceInput!) {
    orderPlace(input: $input) {
      ... on Order {
        id
      }
    }
  }
  """

  test "new orders can be subscribed to", %{socket: socket} do
    # login
    user = Factory.create_user("customer")

    ref =
      push_doc(socket, @login,
        variables: %{
          "email" => user.email
        }
      )

    assert_reply ref, :ok, %{data: %{"login" => %{"token" => _}}}, 2_000

    # setup a subscription
    ref = push_doc(socket, @subscription)
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    # run a mutation to trigger the subscription
    place_order(user)

    expected = %{
      result: %{data: %{"newOrder" => %{"customerId" => user.id}}},
      subscriptionId: subscription_id
    }

    assert_push "subscription:data", push
    assert expected == push
  end

  test "customers can bet see other customer's orders", %{socket: socket} do
    # customer1
    customer1 = Factory.create_user("customer")

    ref =
      push_doc(socket, @login,
        variables: %{
          "email" => customer1.email
        }
      )

    assert_reply ref, :ok, %{data: %{"login" => %{"token" => _}}}, 2_000

    # subscribe to orders
    ref = push_doc(socket, @subscription)
    assert_reply ref, :ok, %{subscriptionId: _subscription_id}

    # customer1 places order
    place_order(customer1)
    assert_push "subscription:data", _

    # customer2 places order
    customer2 = Factory.create_user("customer")
    place_order(customer2)
    refute_receive _
  end

  defp place_order(customer) do
    order_input = %{
      "items" => [%{"quantity" => 2, "menuItemId" => menu_item("Reuben").id}]
    }

    {:ok, %{data: %{"orderPlace" => _}}} =
      Absinthe.run(
        @mutation,
        PlateslateWeb.Schema,
        context: %{current_user: customer},
        variables: %{"input" => order_input}
      )
  end
end
