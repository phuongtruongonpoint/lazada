defmodule Lazada.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :shop_id, :"int8"
      add :category_id, :"int8"
      add :name, :string

      timestamps()
    end

  end
end
