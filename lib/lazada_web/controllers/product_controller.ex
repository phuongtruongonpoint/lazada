defmodule LazadaWeb.ProductController do
  use LazadaWeb, :controller

  alias Lazada.Products
  alias Lazada.Products.Product
  alias Lazada.Accounts
  alias ShopeeCrawler

  plug :check_auth when action in [:new, :create, :edit, :update, :delete, :index, :report]

  def index(conn, _params) do
    products = Products.list_products(_params)
    render(conn, "index.html", products: products.entries, page: products)
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"product" => product_params}) do
    # changeset = Products.crawly_product(product_params)
    # IO.inspect(changeset)
    case ShopeeCrawler.start(product_params["link"]) do
      {:ok, _ } ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: Routes.product_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    IO.inspect(product)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    changeset = Products.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    case Products.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    {:ok, _product} = Products.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end

  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user) do
      current_user = Accounts.get_user!(user_id)

      conn |> assign(:current_user, current_user)
    else
      conn
      |> put_flash(:error, "You need to be signed in to access that page.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  def report(conn, _param) do
    shop_reports = Products.shop_reports()
    category_reports = Products.category_reports()
    # IO.inspect(reports)

    render(conn, "report.html", shop_reports: shop_reports, category_reports: category_reports)
  end
end
