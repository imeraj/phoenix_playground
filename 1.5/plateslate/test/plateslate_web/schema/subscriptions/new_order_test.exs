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
    order_input = %{
      "items" => [%{"quantity" => 2, "menuItemId" => menu_item("Reuben").id}]
    }

    {:ok, %{data: %{"orderPlace" => _}}} =
      Absinthe.run(
        @mutation,
        PlateslateWeb.Schema,
        context: %{current_user: user},
        variables: %{"input" => order_input}
      )

    expected = %{
      result: %{data: %{"newOrder" => %{"customerId" => user.id}}},
      subscriptionId: subscription_id
    }

    assert_push "subscription:data", push
    assert expected == push
  end
end
