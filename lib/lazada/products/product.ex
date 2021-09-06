defmodule Lazada.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "products" do
    field :category_id, :integer
    field :image, :string
    field :name, :string
    field :price, :integer
    field :shop_id, :integer
    field :sku, :integer
    field :stock, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:shop_id, :category_id, :name, :sku, :image, :price, :stock])
    |> validate_required([:shop_id, :category_id, :name, :sku, :image, :price, :stock])
  end

  @spec crawly_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def crawly_changeset(product, attrs) do
    product
    |> cast(attrs, [:link])
    |> validate_required([:link])
  end


  def search(query, params) do

    Enum.reduce(params, query, fn condition, query ->
      {key, value} = condition
      atom_key = String.to_atom(key)
      IO.inspect(condition)

      case Integer.parse(value) do
        {number, _} -> from product in query, where: field(product, ^atom_key) == ^number
        _ ->
          search_term = "%#{value}%"
          from product in query, where: ilike(field(product, ^atom_key), ^search_term)
      end
    end)

  end
end
