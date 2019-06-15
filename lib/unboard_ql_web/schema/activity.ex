defmodule UnboardQlWeb.Schema.Activity do
  use Absinthe.Schema.Notation
  alias UnboardQlWeb.Resolvers

  object :activity do
    field :id, :id
    field :type, :string
    field :description, :string
    field :image_url, :string
    field :participant_capacity, :integer
    field :registered_participants, :integer
    field :price, :float
    field :accessibility, :float
    field :start_time, :integer
    field :end_time, :integer
    field :location_id, :integer
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
