defmodule Lazada.Repo.Migrations.CreateShops do
  use Ecto.Migration

  def change do
    create table(:shops) do
      add :shop_id, :"int8"
      add :name, :string

      timestamps()
    end

  end
end
