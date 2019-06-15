defmodule UnboardQlWeb.Schema do
  use Absinthe.Schema
  import_types UnboardQlWeb.Schema.Location
  import_types UnboardQlWeb.Schema.User
  import_types UnboardQlWeb.Schema.Activity

  alias UnboardQlWeb.Resolvers

  query do
    @desc "Get all activities"
    field :activities, list_of(:activity) do
      arg :sponsored, :boolean
      resolve &Resolvers.list_activities/3
    end
  end

end
