defmodule Lani.Events do
  @moduledoc """
  The Events context.
  """
  import Ecto.Query, warn: false
  alias Lani.Repo
  alias Lani.Events.Guide
  alias Lani.Events.Category

  def list_alphabetical_categories do
    Category
    |> Category.alphabetical()
    |> Repo.all()
  end


  def list_guides_with_category(id) do
    Guide
    |> Repo.get(id)
    |> Repo.preload(:category)
    |> Repo.all()
  end

       

  @doc """
  Returns the list of guides.

  ## Examples

      iex> list_guides()
      [%Guide{}, ...]

  """
  def list_guides do
    # Repo.all(Guide)
    Guide
    |> Repo.all()
    |> Repo.preload(:category)
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

  # ----------------------------------------------------------------------------------------

  alias Lani.Events.Category
  
  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
    # TRY THIS FOR LAST LINE Repo.get_by(Category, name: name) || Repo.insert!(%Category{name: name})
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
