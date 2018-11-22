defmodule Lani.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Lani.Repo
  alias Lani.Events.Guide
  alias Lani.Events.Category


  def create_category(name) do
    Repo.get_by(Category, name: name) || Repo.insert!(%Category{name: name})
  end

  def list_alphabetical_categories do
    Category
    |> Category.alphabetical()
    |> Repo.all()
  end

  def get_category!(category_id), do: Repo.get!(Category, category_id)

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end
  @doc """
  Returns the list of guides.

  ## Examples

      iex> list_guides()
      [%Guide{}, ...]

  """
  def list_guides do
    Repo.all(Guide)
  end

  @doc """
  Gets a single guide.

  Raises `Ecto.NoResultsError` if the Guide does not exist.

  ## Examples

      iex> get_guide!(123)
      %Guide{}

      iex> get_guide!(456)
      ** (Ecto.NoResultsError)

  """
  def get_guide!(id), do: Repo.get!(Guide, id)

  @doc """
  Creates a guide.

  ## Examples

      iex> create_guide(%{field: value})
      {:ok, %Guide{}}

      iex> create_guide(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_guide(attrs \\ %{}) do
    %Guide{}
    |> Guide.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a guide.

  ## Examples

      iex> update_guide(guide, %{field: new_value})
      {:ok, %Guide{}}

      iex> update_guide(guide, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_guide(%Guide{} = guide, attrs) do
    guide
    |> Guide.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Guide.

  ## Examples

      iex> delete_guide(guide)
      {:ok, %Guide{}}

      iex> delete_guide(guide)
      {:error, %Ecto.Changeset{}}

  """
  def delete_guide(%Guide{} = guide) do
    Repo.delete(guide)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking guide changes.

  ## Examples

      iex> change_guide(guide)
      %Ecto.Changeset{source: %Guide{}}

  """
  def change_guide(%Guide{} = guide) do
    Guide.changeset(guide, %{})
  end
end
