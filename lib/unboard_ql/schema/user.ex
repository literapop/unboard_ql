defmodule UnboardQl.User do
  use Ecto.Schema

  schema "user" do
    field :email, :string
    field :password, :string
    field :first_name, :string
    field :last_name, :string
    timestamps()
  end
end
