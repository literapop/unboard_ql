defmodule UnboardQl.ActivityRating do
  use Ecto.Schema
  alias UnboardQl.{Activity, User}

  schema "activity_rating" do
    belongs_to(:activity, Activity)
    belongs_to(:user, User)
    field :rating, :integer
    timestamps()
  end
end
