defmodule PlateslateWeb.Schema.Subscription.UpdateOrderTest do
  use PlateslateWeb.SubscriptionCase

  @subscription """
  subscription ($id: ID! ){
    updateOrder(id: $id) { state }
  }
  """

  @mutation """
  mutation ($id: ID!) {
    readyOrder(id: $id) {
      ... on Errors {
        errors {
          key
          message
        }
      }
    }
  }
  """

  test "subscribe to order updates", %{socket: socket} do
    reuben = menu_item("Reuben")

    {:ok, order1} =
      Plateslate.Ordering.create_order(%{
        customer_number: 123,
        items: [%{menu_item_id: reuben.id, quantity: 2}]
      })

    {:ok, order2} =
      Plateslate.Ordering.create_order(%{
        customer_number: 124,
        items: [%{menu_item_id: reuben.id, quantity: 1}]
      })

    ref = push_doc(socket, @subscription, variables: %{"id" => order1.id})
    assert_reply ref, :ok, %{subscriptionId: _subscription_ref1}

    ref = push_doc(socket, @subscription, variables: %{"id" => order2.id})
    assert_reply ref, :ok, %{subscriptionId: subscription_ref2}

    ref = push_doc(socket, @mutation, variables: %{"id" => order2.id})
    assert_reply ref, :ok, reply

    refute reply[:errors]
    refute reply[:data]["readyOrder"]["errors"]

    assert_push "subscription:data", push

    expected = %{
      result: %{data: %{"updateOrder" => %{"state" => "ready"}}},
      subscriptionId: subscription_ref2
    }

    assert expected == push
  end
end
