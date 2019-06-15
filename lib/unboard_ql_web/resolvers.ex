defmodule UnboardQlWeb.Resolvers do

  def list_activities(_parent, _args, _resolution) do
    # {:ok, UnboardQl.Activities.list_posts()}
    {:ok, []}
  end
end
