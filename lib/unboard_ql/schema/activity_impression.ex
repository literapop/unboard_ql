defmodule UnboardQl.ActivityImpression do
  use Ecto.Schema
  alias UnboardQl.{Activity, User}

  schema "activity_impression" do
    belongs_to(:activity, Activity)
    belongs_to(:user, User)
    timestamps()
  end
end
