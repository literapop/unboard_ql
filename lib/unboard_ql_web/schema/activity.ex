defmodule UnboardQlWeb.Schema.Activity do
  use Absinthe.Schema.Notation
  alias UnboardQlWeb.Resolvers

  object :ad do

  end

  object :activity do
    field :id, :id
    field :type, :activity_type do
      resolve &Resolvers.type/3
    end
    field :name, :string
    field :description, :string
    field :image_url, :string do
      resolve &Resolvers.image_url/3
    end
    field :participant_capacity, :integer
    # field :registered_participants, list_of(:user) do
    #   resolve &Resolvers.activity_participants/3
    # end
    field :price, :float
    field :accessibility, :float
    field :start_time, :integer
    field :end_time, :integer
    field :creator, :user do
      resolve &Resolvers.user/3
    end
    field :location, :location do
      resolve &Resolvers.location/3
    end
    field :sponsored, :boolean
    field :link, :string
  end

end
