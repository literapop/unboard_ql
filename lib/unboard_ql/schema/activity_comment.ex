defmodule UnboardQl.ActivityComment do
  use Ecto.Schema
  alias UnboardQl.{Activity, User}

  schema "activity_comment" do
    belongs_to(:activity, Activity)
    belongs_to(:user, User)
    field :content, :string
    timestamps()
  end
end
