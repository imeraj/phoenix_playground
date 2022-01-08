defmodule Pento.Survey do
  @moduledoc """
  The Survey context.
  """

  import Ecto.Query, warn: false
  alias Pento.Repo

  alias Pento.Survey.Demographic

  @doc """
  Returns the list of demographics.

  ## Examples

      iex> list_demographics()
      [%Demographic{}, ...]

  """
  def list_demographics do
    Repo.all(Demographic)
  end

  @doc """
  Gets a single demographic.

  Raises `Ecto.NoResultsError` if the Demographic does not exist.

  ## Examples

      iex> get_demographic!(123)
      %Demographic{}

      iex> get_demographic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_demographic!(id), do: Repo.get!(Demographic, id)

  @doc """
  Creates a demographic.

  ## Examples

      iex> create_demographic(%{field: value})
      {:ok, %Demographic{}}

      iex> create_demographic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_demographic(attrs \\ %{}) do
    %Demographic{}
    |> Demographic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a demographic.

  ## Examples

      iex> update_demographic(demographic, %{field: new_value})
      {:ok, %Demographic{}}

      iex> update_demographic(demographic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_demographic(%Demographic{} = demographic, attrs) do
    demographic
    |> Demographic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a demographic.

  ## Examples

      iex> delete_demographic(demographic)
      {:ok, %Demographic{}}

      iex> delete_demographic(demographic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_demographic(%Demographic{} = demographic) do
    Repo.delete(demographic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking demographic changes.

  ## Examples

      iex> change_demographic(demographic)
      %Ecto.Changeset{data: %Demographic{}}

  """
  def change_demographic(%Demographic{} = demographic, attrs \\ %{}) do
    Demographic.changeset(demographic, attrs)
  end

  def get_demographic_by_user(user) do
    user
    |> Demographic.Query.for_user()
    |> Repo.one()
  end

  alias Pento.Survey.Rating

  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings()
      [%Rating{}, ...]

  """
  def list_ratings do
    Repo.all(Rating)
  end

  @doc """
  Gets a single rating.

  Raises `Ecto.NoResultsError` if the Rating does not exist.

  ## Examples

      iex> get_rating!(123)
      %Rating{}

      iex> get_rating!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rating!(id), do: Repo.get!(Rating, id)

  @doc """
  Creates a rating.

  ## Examples

      iex> create_rating(%{field: value})
      {:ok, %Rating{}}

      iex> create_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rating(attrs \\ %{}) do
    %Rating{}
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rating.

  ## Examples

      iex> update_rating(rating, %{field: new_value})
      {:ok, %Rating{}}

      iex> update_rating(rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rating.

  ## Examples

      iex> delete_rating(rating)
      {:ok, %Rating{}}

      iex> delete_rating(rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.

  ## Examples

      iex> change_rating(rating)
      %Ecto.Changeset{data: %Rating{}}

  """
  def change_rating(%Rating{} = rating, attrs \\ %{}) do
    Rating.changeset(rating, attrs)
  end
end
