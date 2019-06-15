defmodule UnboardQlWeb.Resolvers do
  require Logger
  alias UnboardQl.{ActivityType, Activity, Location, Repo, User}
  import Ecto.Changeset

  def activity_participants(%{id: id}, _args, _resolution) do
    activity =
      Repo.get(Activity, id)
      |> Repo.preload(:participants)

    {:ok, activity.participants}
  end

  def activity_participants(_parent, _args, _resolution) do
    {:ok, []}
  end

  def list_activities(_parent, _args, _resolution) do
    # {:ok, UnboardQl.Activities.list_posts()}
    {:ok, Repo.all(Activity)}
  end

  @spec type(any, any, any) :: any
  def type(%{type_id: type_id} = _parent, _args, _resolution) do
    {:ok, Repo.get(ActivityType, type_id)}
  end

  def type(%{type: name} = _parent, _args, _resolution) when is_binary(name) do
    case Repo.get_by(ActivityType, name: name) do
      nil ->
        Repo.insert(%ActivityType{name: name})

      type ->
        {:ok, type}
    end
  end

  def type(_parent, _args, _resolution) do
    {:ok, nil}
  end

  def nouns(%{name: name}, _args, _resolution) do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
      HTTPoison.post("http://text-processing.com/api/tag/", "text=#{name}")

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
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
      HTTPoison.get(
        "https://api.giphy.com/v1/gifs/search?api_key=vykG20aQiE7C8eVLDbHZlXa33sBfE2Rp&q=#{
          URI.encode(name)
        }&limit=25&offset=0&rating=PG-13&lang=en"
      )

    {:ok, %{"data" => items}} = Jason.decode(body)

    Logger.debug(inspect(items))

    case items do
      nil ->
        {:ok, nil}

      [] ->
        {:ok, nil}

      items ->
        {:ok, get_in(Enum.random(items), ["images", "original", "url"])}
    end
  end

  def image_url(parent, _args, _resolution) do
    Logger.debug(inspect(parent))
    {:ok, nil}
  end

  def location(%{location_id: location_id} = _parent, _args, _resolution) do
    {:ok, Repo.get(Location, location_id)}
  end

  def user(%{creator_id: creator_id} = _parent, _args, _resolution) do
    {:ok, Repo.get(User, creator_id)}
  end

  def create_activity(_parent, args, _resolution) do
    Repo.insert(Map.merge(%Activity{}, args))
  end

  def create_user(
        _parent,
        %{email: email, password: password, first_name: first_name, last_name: last_name},
        _resolution
      ) do
    case Repo.get_by(User, email: email) do
      nil ->
        Repo.insert(%User{
          email: email,
          password: password,
          first_name: first_name,
          last_name: last_name
        })

      user ->
        {:ok, user}
    end
  end

  def register_participant(_parent, %{user_id: user_id, activity_id: activity_id}, _resolution) do
    user = Repo.get(User, user_id)
    activity = Repo.get(Activity, activity_id)

    cond do
      is_nil(user) ->
        {:error, "no such user"}

      is_nil(activity) ->
        {:error, "no such activity"}

      true ->
        activity
        |> Repo.preload(:participants)
        |> change()
        |> put_assoc(:participants, [user])
        |> Repo.update()
    end
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
