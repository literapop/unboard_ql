defmodule UnboardQlWeb.Schema.ActivityType do
  use Absinthe.Schema.Notation

  object :activity_type do
    field :id, :id
    field :name, :string
  end
end
