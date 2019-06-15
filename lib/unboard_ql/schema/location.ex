defmodule UnboardQl.Location do
  use Ecto.Schema

  schema "location" do
    field :name, :string
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :lat, :decimal
    field :long, :decimal
    timestamps()
  end
end
