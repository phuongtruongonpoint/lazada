defmodule Lazada.ProductsTest do
  use Lazada.DataCase

  alias Lazada.Products

  describe "products" do
    alias Lazada.Products.Product

    @valid_attrs %{category_id: 42, image: "some image", name: "some name", price: 42, shop_id: 42, sku: 42, stock: 42}
    @update_attrs %{category_id: 43, image: "some updated image", name: "some updated name", price: 43, shop_id: 43, sku: 43, stock: 43}
    @invalid_attrs %{category_id: nil, image: nil, name: nil, price: nil, shop_id: nil, sku: nil, stock: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.category_id == 42
      assert product.image == "some image"
      assert product.name == "some name"
      assert product.price == 42
      assert product.shop_id == 42
      assert product.sku == 42
      assert product.stock == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.category_id == 43
      assert product.image == "some updated image"
      assert product.name == "some updated name"
      assert product.price == 43
      assert product.shop_id == 43
      assert product.sku == 43
      assert product.stock == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
