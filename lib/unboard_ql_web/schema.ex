defmodule UnboardQlWeb.Schema do
  use Absinthe.Schema

  import_types UnboardQlWeb.Schema.User
  import_types UnboardQlWeb.Schema.Location
  import_types UnboardQlWeb.Schema.ActivityType
  import_types UnboardQlWeb.Schema.Activity

  object :comment do
    field :content, :string
    field :user, :user do
      resolve &Resolvers.user/3
    end
  end

  object :ad_image do
    field :href, :string
  end

  object :ad do
    field :name, :string
    field :sale_price, :string
    field :url, :string
    field :images, list_of(:ad_image)
  end

  alias UnboardQlWeb.Resolvers

  query do
    @desc "Get all activities"
    field :activities, list_of(:activity) do
      arg :sponsored, :boolean
      arg :creator_id, :integer
      arg :type_id, :string
      resolve &Resolvers.list_activities/3
    end

    @desc "Get an activity suggestion"
    field :suggestion, :activity do
      arg :participants, :integer
      arg :accessibility, :float
      arg :price, :float
      arg :type, :string
      resolve &Resolvers.suggestion/3
    end

    @desc "Get a user"
    field :user, :user do
      arg :email, :string
      arg :id, :integer
      resolve &Resolvers.user/3
    end

    @desc "Get a list of types"
    field :types, list_of(:activity_type) do
      resolve &Resolvers.list_types/3
    end
  end

  mutation do
    @desc "Create an activity"
    field :create_activity, type: :activity do
      arg :type_id, :integer
      arg :type, :string
      arg :name, non_null(:string)
      arg :description, non_null(:string)
      arg :image_url, :string
      arg :participant_capacity, non_null(:integer)
      arg :price, non_null(:float)
      arg :accessibility, non_null(:float)
      arg :start_time, :integer
      arg :end_time, :integer
      arg :creator_id, non_null(:integer)
      arg :location_id, :integer
      arg :sponsored, :boolean
      arg :link, :string

      resolve &Resolvers.create_activity/3
    end

    @desc "Create a user"
    field :create_user, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :first_name, :string
      arg :last_name, :string

      resolve &Resolvers.create_user/3
    end

    @desc "Add an activity comment"
    field :activity_comment, type: :activity do
      arg :user_id, non_null(:integer)
      arg :activity_id, non_null(:integer)
      arg :content, non_null(:string)

      resolve &Resolvers.record_comment/3
    end


    @desc "Register participant to activity"
    field :register_participant, type: :activity do
      arg :user_id, non_null(:integer)
      arg :activity_id, non_null(:integer)

      resolve &Resolvers.register_participant/3
    end

    @desc "Like an activity"
    field :like_activity, type: :activity do
      arg :user_id, non_null(:integer)
      arg :activity_id, non_null(:integer)

      resolve &Resolvers.like_activity/3
    end

    @desc "Record an impression"
    field :record_impression, type: :activity do
      arg :user_id, non_null(:integer)
      arg :activity_id, non_null(:integer)

      resolve &Resolvers.record_impression/3
    end

    @desc "Delete an activity"
    field :delete_activity, type: :activity do
      arg :user_id, non_null(:integer)
      arg :activity_id, non_null(:integer)

      resolve &Resolvers.delete_activity/3
    end
  end

end
