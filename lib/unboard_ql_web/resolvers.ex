defmodule UnboardQlWeb.Resolvers do
  require Logger

  def list_activities(_parent, _args, _resolution) do
    # {:ok, UnboardQl.Activities.list_posts()}
    {:ok, UnboardQl.Repo.all(UnboardQl.Activity)}
  end

  def type(%{type_id: type_id} = _parent, _args, _resolution) do
    {:ok, UnboardQl.Repo.get(UnboardQl.ActivityType, type_id)}
  end

  def type(%{type: name} = _parent, _args, _resolution) when is_binary(name) do
    case UnboardQl.Repo.get_by(UnboardQl.ActivityType, name: name) do
      nil ->
        UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: name})

      type ->
        {:ok, type}
    end
  end
  def type(_parent, _args, _resolution) do
    {:ok, nil}
  end

  def ads(%{name: name}, _args, _resolution) do
    namex = "cat"
    #{:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.get("https://api.bestbuy.com/v1/products(name=#{URI.encode(namex)}*)?show=sku,name,salePrice,url,mobileUrl,images&pageSize=5&page=1&apiKey=0b69b3VYXZqXmAoJFlvNbPKI&format=json")
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.get("https://api.bestbuy.com/v1/products(name=#{URI.encode(namex)}*)?show=sku,name,salePrice&pageSize=5&page=1&apiKey=0b69b3VYXZqXmAoJFlvNbPKI&format=json", [], [ssl: [{:versions, [:'tlsv1.2']}]])
    {:ok, %{"products" => products}} = Jason.decode(body)
    Logger.debug(inspect(products))

    product_list = Enum.map(products, fn %{
      "name" => name,
      "salePrice" => sale_price,
      "sku" => sku,
      "url" => url
      } -> %{
      name: name,
        sku: sku,
        sale_price: sale_price,
        url: url
      }
    end)

    case product_list do
      nil -> {:ok, []}
      [] -> {:ok,nil}
      ads -> {:ok, product_list}
    end
  end
  def ads(_parent, _args, _resolution) do
    {:ok, []}
  end

  def nouns(%{name: name}, _args, _resolution) do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.post("http://text-processing.com/api/tag/", "text=#{name}")
    {:ok, %{"text" => text}} = Jason.decode(body)
    case Regex.run(~r/(\w+)\/NN\b/, text, capture: :all_but_first) do
      nil -> {:ok, []}
      nouns -> {:ok, Enum.map(nouns, &String.downcase/1)}
    end
  end
  def nouns(_parent, _args, _resolution) do
    {:ok, []}
  end

  def image_url(%{image_url: image_url, name: name}, _args, _resolution) when image_url == nil do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.get("https://api.giphy.com/v1/gifs/search?api_key=vykG20aQiE7C8eVLDbHZlXa33sBfE2Rp&q=#{URI.encode(name)}&limit=25&offset=0&rating=PG-13&lang=en")
    {:ok, %{"data" => items}} = Jason.decode(body)

    Logger.debug(inspect(items))
    case items do
      nil -> {:ok, nil}
      [] -> {:ok, nil}
      items ->
        {:ok, get_in(Enum.random(items), ["images", "original", "url"])}
    end
  end
  def image_url(parent, _args, _resolution) do
    Logger.debug(inspect(parent))
    {:ok, nil}
  end

  def location(%{location_id: location_id} = _parent, _args, _resolution) do
    {:ok, UnboardQl.Repo.get(UnboardQl.Location, location_id)}
  end

  def user(%{creator_id: creator_id} = _parent, _args, _resolution) do
    {:ok, UnboardQl.Repo.get(UnboardQl.User, creator_id)}
  end

  def create_activity(_parent, args, _resolution) do
    UnboardQl.Repo.insert(Map.merge(%UnboardQl.Activity{}, args))
  end

  def suggestion(_parent, args, _resolution) do
    {:ok, response} = HTTPoison.get("https://www.boredapi.com/api/activity", [], params: args)
    {:ok, decoded} = Jason.decode(response.body)
    Logger.debug(inspect(decoded))

    case decoded do
      %{"error" => error} ->
        {:error, error}

      %{
        "accessibility" => accessibility,
        "price" => price,
        "type" => type,
        "participants" => participant_capacity,
        "activity" => name
      } ->
        {:ok,
         %{
           accessibility: accessibility,
           price: price,
           type: type,
           participant_capacity: participant_capacity,
           name: name,
           image_url: nil
         }}
    end
  end
end
