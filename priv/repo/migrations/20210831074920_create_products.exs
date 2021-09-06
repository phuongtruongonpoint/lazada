defmodule Lazada.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :shop_id, :"int8"
      add :category_id, :"int8"
      add :name, :string
      add :sku, :"int8"
      add :image, :string
      add :price, :"int8"
      add :stock, :"int8"

      timestamps()
    end

  end
end
