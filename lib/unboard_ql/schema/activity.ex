defmodule UnboardQl.Activity do
  use Ecto.Schema
  alias UnboardQl.{ActivityComment, ActivityImpression, ActivityRating, ActivityType, Location, User}

  schema "activity" do
    field :name, :string
    field :description, :string
    field :image_url, :string
    field :participant_capacity, :integer
    field :registered_participants, :integer
    field :price, :float
    field :accessibility, :float
    field :start_time, :integer
    field :end_time, :integer
    field :sponsored, :boolean
    field :link, :string
    belongs_to(:location, Location)
    belongs_to(:type, ActivityType)
    belongs_to(:creator, User)
    many_to_many(:participants, User, join_through: "activity_participant")
    many_to_many(:likes, User, join_through: "activity_like")
    has_many(:comments, ActivityComment)
    has_many(:ratings, ActivityRating)
    has_many(:impressions, ActivityImpression)
    timestamps()
  end
end
