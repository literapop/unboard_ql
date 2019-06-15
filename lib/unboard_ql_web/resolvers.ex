defmodule UnboardQlWeb.Resolvers do

  def list_activities(_parent, _args, _resolution) do
    # {:ok, UnboardQl.Activities.list_posts()}
    {:ok, UnboardQl.Repo.all(UnboardQl.Activity)}
  end

  def type(%{type_id: type_id} = _parent, _args, _resolution) do
    {:ok, UnboardQl.Repo.get(UnboardQl.ActivityType, type_id)}
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
end
