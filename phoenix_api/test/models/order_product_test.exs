defmodule PhoenixApi.OrderProductTest do
  use PhoenixApi.ModelCase

  alias PhoenixApi.OrderProduct

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = OrderProduct.changeset(%OrderProduct{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OrderProduct.changeset(%OrderProduct{}, @invalid_attrs)
    refute changeset.valid?
  end
end
