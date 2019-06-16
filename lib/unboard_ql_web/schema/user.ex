defmodule UnboardQlWeb.Schema.User do
  use Absinthe.Schema.Notation
  alias UnboardQlWeb.Resolvers

  object :user do
    field :id, :id
    field :email, :string
    field :password, :string
    field :first_name, :string
    field :last_name, :string
    field :owned_activities, list_of(:activity) do
      resolve &Resolvers.list_activities/3
    end
    field :participating_activities, list_of(:activity) do
      resolve &Resolvers.list_participting_activities/3
    end
  end
end
