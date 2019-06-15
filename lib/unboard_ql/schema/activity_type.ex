defmodule UnboardQl.ActivityType do
  use Ecto.Schema

  schema "activity_type" do
    field :name, :string
    timestamps()
  end
end
