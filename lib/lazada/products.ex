defmodule Lazada.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Lazada.Repo

  alias Lazada.Products.Product
  alias Lazada.Products.Category
  alias Lazada.Products.Shop

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @spec list_products(any) :: Scrivener.Page.t()
  def list_products(params) do
    search_term = Enum.filter(params, fn el ->
      {_, val} = el
      case String.length(val) do
        x when x > 0 -> true
        _ -> false
      end
    end)


    IO.inspect(search_term)
    Product
    |> Product.search(search_term)
    |> Repo.paginate()
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
    case Repo.get_by(Product, sku: attrs[:sku]) do
      nil -> %Product{}
      product -> product
    end
    |> Product.changeset(attrs)
    |> Repo.insert_or_update
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def create_category(attrs \\ %{}) do
    case Repo.get_by(Category, category_id: attrs[:category_id]) do
      nil -> %Category{}
      category -> category
    end
    |> Category.changeset(attrs)
    |> Repo.insert_or_update
  end

  def create_shop(attrs \\ %{}) do
    case Repo.get_by(Shop, shop_id: attrs[:shop_id]) do
      nil -> %Shop{}
      shop -> shop
    end
    |> Shop.changeset(attrs)
    |> Repo.insert_or_update
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def crawly_product(product, attrs \\ %{}) do
    Product.crawly_changeset(product, attrs)
  end

  def shop_reports() do
    Product
    |> group_by(:shop_id)
    |> select([p], %{:shop_id => p.shop_id, :total_product => count(p.shop_id)})
    |> Repo.all()
  end

  def category_reports() do
    Product
    |> group_by(:category_id)
    |> select([p], %{:category_id => p.category_id, :total_product => count(p.category_id)})
    |> Repo.all()
  end
end
