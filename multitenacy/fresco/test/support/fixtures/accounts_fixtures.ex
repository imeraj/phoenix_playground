defmodule Fresco.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fresco.Accounts` context.
  """

  @doc """
  Generate a unique account name.
  """
  def unique_account_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        brand_colour: "some brand_colour",
        name: unique_account_name()
      })
      |> Fresco.Accounts.create_account()

    account
  end
end
