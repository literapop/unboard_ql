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
           name: name
         }}
    end
  end
end
