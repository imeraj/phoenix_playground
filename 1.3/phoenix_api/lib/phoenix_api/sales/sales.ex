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
    Repo.all(from(p in Product, where: p.published == true))
  end

  def get_product_page(page, page_size) do
    Product
    |> where([p], p.published == true)
    |> Repo.paginate(page: page, page_size: page_size)
  end

  def get_products_by_ids(ids) do
    Product
    |> where([p], p.published == true)
    |> where([p], p.id in ^ids)
    |> Repo.all()
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
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
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

  alias PhoenixApi.Sales.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id) do
    ConCache.get_or_store(:db_cache, :get_order_by_id, fn ->
      Repo.get!(Order, id) |> Repo.preload(:sales_products)
    end)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    order_total =
      Map.get(attrs, "product_ids")
      |> calculate_order_total()

    new_attrs =
      attrs
      |> Map.put_new("total", order_total)

    %Order{}
    |> Order.changeset(new_attrs)
    |> Repo.insert()
  end

  defp calculate_order_total(ids) do
    query =
      from(
        p in Product,
        select: p.price,
        where: p.id in ^ids
      )

    Repo.all(query)
    |> Enum.reduce(Decimal.new(0), &Decimal.add/2)
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end
end
