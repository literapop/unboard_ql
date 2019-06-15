defmodule UnboardQlWeb.Schema.Location do
  use Absinthe.Schema.Notation

  object :location do
    field :id, :id
    field :name, :string
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :lat, :float
    field :long, :float
  end
end
