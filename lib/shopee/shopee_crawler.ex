defmodule ShopeeCrawler do
  alias Lazada.Products

  @limit 10

  def base_url(), do: "https://shopee.vn/api/v4/search/search_items?by=pop&order=desc&page_type=shop&scenario=PAGE_OTHERS&version=2"

  def category_url(), do: "https://shopee.vn/api/v4/shop/get_categories?limit=100&offset=0"

  def domain(), do: "https://shopee.vn/"

  def start_default() do
    start("https://shopee.vn/apple_flagship_store")
  end

  def start(shop_link) do
    shop_id = get_shop(shop_link)
    shop_store_data %{
      :shop_id => shop_id,
      :name => String.replace(shop_link, domain(), "")
    }

    api_link = base_url() <> "&limit=#{@limit}&match_id=#{shop_id}"
    fetch(api_link)

    api_category_link = category_url() <> "&shopid=#{shop_id}"
    category_fetch(api_category_link, shop_id)

    {
      :ok,
      "Success"
    }
  end

  def get_shop(link) do
    response = Crawly.fetch(link)
    {:ok, document} = Floki.parse_document(response.body)
    [shop_link | _] = document |> Floki.find("div[role=main] > div[class^=mobilemall-shop] a[class^=mobilemall-shop]") |> Floki.attribute("href")
    shop_link |> String.split("/") |> get_shop_id
  end

  def fetch(url, begin \\ 0) do
    url_fetch = url <> "&newest=#{begin}"
    IO.inspect(url_fetch)
    response = Crawly.fetch(url_fetch)
    {:ok, body} = Jason.decode(response.body)

    case body["error"] do
      data when data in [nil, 0] ->
        Enum.map(body["items"], fn item ->
          store_data %{
            :name => item["item_basic"]["name"],
            :image => item["item_basic"]["image"],
            :price => item["item_basic"]["price"],
            :category_id => item["item_basic"]["catid"],
            :stock => item["item_basic"]["stock"],
            :sku => item["item_basic"]["itemid"],
            :shop_id => item["item_basic"]["shopid"]
          }
        end)

        unless body["nomore"], do: fetch(url, begin + @limit)

      _ -> []
    end
  end

  def store_data(item) do
    case Products.create_product(item) do
      {:ok, product} -> IO.inspect(product)
      {:error, %Ecto.Changeset{} = changeset} -> IO.inspect(changeset)
    end
  end

  def category_fetch(url, shop_id) do
    IO.inspect(url)
    response = Crawly.fetch(url)
    {:ok, body} = Jason.decode(response.body)

    case body["error"] do
      data when data in [nil, 0] ->
        Enum.map(body["data"]["shop_categories"], fn item ->
          category_store_data %{
            :name => item["display_name"],
            :category_id => item["shop_category_id"],
            :shop_id => shop_id
          }
        end)

      _ -> []
    end
  end

  def category_store_data(item) do
    case Products.create_category(item) do
      {:ok, category} -> IO.inspect(category)
      {:error, %Ecto.Changeset{} = changeset} -> IO.inspect(changeset)
    end
  end

  def shop_store_data(item) do
    case Products.create_shop(item) do
      {:ok, shop} -> IO.inspect(shop)
      {:error, %Ecto.Changeset{} = changeset} -> IO.inspect(changeset)
    end
  end

  defp get_shop_id([head | tail]) do
    case Integer.parse(head) do
      {shop_id, _} -> shop_id
      _ -> get_shop_id(tail)
    end
  end
  defp get_shop_id([]), do: nil
end
