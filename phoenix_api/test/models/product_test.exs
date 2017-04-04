defmodule PhoenixApi.ProductTest do
  use PhoenixApi.ModelCase

  alias PhoenixApi.Product

  @valid_attrs %{price: "120.5", published: true, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
