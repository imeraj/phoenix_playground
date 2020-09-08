defmodule PlateslateWeb.Schema.Subscription.NewOrderTest do
  use PlateslateWeb.SubscriptionCase

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
    # setup a subscription
    ref = push_doc(socket, @subscription)
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    # run a mutation to trigger the subscription
    order_input = %{
      "items" => [%{"quantity" => 2, "menuItemId" => menu_item("Reuben").id}]
    }

    customer = Factory.create_user("customer")

    {:ok, %{data: %{"orderPlace" => _}}} =
      Absinthe.run(
        @mutation,
        PlateslateWeb.Schema,
        context: %{current_user: customer},
        variables: %{"input" => order_input}
      )

    expected = %{
      result: %{data: %{"newOrder" => %{"customerId" => customer.id }}},
      subscriptionId: subscription_id
    }

    assert_push "subscription:data", push
    assert expected == push
  end
end
