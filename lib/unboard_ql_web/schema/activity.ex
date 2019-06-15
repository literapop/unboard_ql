defmodule UnboardQlWeb.Schema.Activity do
  use Absinthe.Schema.Notation

  scalar :datetime do
    description "Date/Time (in unix)"
    parse &DateTime.from_unix!(&1)
    serialize &DateTime.to_unix(&1)
  end

  object :location do
    field :name, :string
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :lat, :string
    field :long, :string
  end

  object :activity do
    field :id, :id
    field :type, :string
    field :description, :string
    field :image_url, :string
    field :participant_capacity, :integer
    field :registered_participants, :integer
    field :price, :float
    field :accessibility, :float
    field :start_time, :datetime
    field :end_time, :datetime
    field :location, :location
    field :sponsored, :boolean
    field :link, :string
  end

end
