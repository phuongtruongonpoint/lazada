defmodule Lazada.Products.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "categories" do
    field :shop_id, :integer
    field :category_id, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:shop_id, :category_id, :name])
    |> validate_required([:shop_id, :category_id, :name])
  end
end
