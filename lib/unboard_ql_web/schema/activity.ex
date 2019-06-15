defmodule UnboardQlWeb.Schema.Activity do
  use Absinthe.Schema.Notation
  alias UnboardQlWeb.Resolvers

  object :ad_image do
    field :href, :string
  end

  object :ad do
    field :name, :string
    field :sale_price, :string
    field :url, :string
    field :images, list_of(:ad_image)
  end

  object :comment do
    field :content, :string
    field :user, :user do
      resolve &Resolvers.user/3
    end
  end

  object :activity do
    field :id, :id
    field :type, :activity_type do
      resolve &Resolvers.type/3
    end

    field :comments, list_of(:comment) do
      resolve &Resolvers.activity_comments/3
    end

    field :name, :string
    field :description, :string
    field :image_url, :string do
      resolve &Resolvers.image_url/3
    end
    field :participant_capacity, :integer
    field :registered_participants, list_of(:user) do
      resolve &Resolvers.activity_participants/3
    end
    field :like_count, :integer do
      resolve &Resolvers.likes/3
    end
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
    field :ads, list_of(:ad) do
      resolve &Resolvers.ads/3
    end
  end

end
