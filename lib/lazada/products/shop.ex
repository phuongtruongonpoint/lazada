defmodule Lazada.Products.Shop do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "shops" do
    field :shop_id, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:shop_id, :name])
    |> validate_required([:shop_id, :name])
  end
end
