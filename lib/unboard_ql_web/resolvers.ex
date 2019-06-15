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

  def nouns(%{name: name}, _args, _resolution) do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.post("http://text-processing.com/api/tag/", "text=#{name}")
    {:ok, %{"text" => text}} = Jason.decode(body)
    nouns = Regex.run(~r/(\w+)\/NN/, text, capture: :all_but_first)
    {:ok, nouns}
  end
  def nouns(_parent, _args, _resolution) do
    {:ok, []}
  end

  def image_url(%{image_url: image_url, name: name}, _args, _resolution) when image_url == nil do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.get("https://api.giphy.com/v1/gifs/search?api_key=vykG20aQiE7C8eVLDbHZlXa33sBfE2Rp&q=#{URI.encode(name)}&limit=25&offset=0&rating=PG-13&lang=en")
    {:ok, %{"data" => items}} = Jason.decode(body)

    Logger.debug(inspect(items))
    case Enum.random(items) do
      nil ->
        {:ok, nil}
      item ->
        {:ok, get_in(item, ["images", "fixed_width", "url"])}
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
