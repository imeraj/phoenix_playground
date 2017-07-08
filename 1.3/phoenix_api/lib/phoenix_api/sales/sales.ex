defmodule PhoenixApi.Sales do
  @moduledoc """
  The boundary for the Sales system.
  """

  import Ecto.Query, warn: false
  alias PhoenixApi.Repo

  alias PhoenixApi.Sales.Product
  alias PhoenixApi.Accounts.User

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(from p in Product, where: p.published == true)
  end

  def get_product_page(page, page_size) do
    Product
    |> where([p], p.published == true)
    |> Repo.paginate(page: page, page_size: page_size)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}, %User{} = user) do
    %Product{}
    |> Product.changeset(Map.put_new(attrs, "accounts_users_id", user.id))
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs, %User{} = user) do
    cond do
      product.accounts_users_id == user.id ->
          product
          |> Product.changeset(attrs)
          |> Repo.update()
      true ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product, %User{} = user) do
    cond do
      product.accounts_users_id == user.id ->
        Repo.delete(product)
      true ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end
end
