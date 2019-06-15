defmodule UnboardQlWeb.Schema.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
    field :password, :string
    field :first_name, :string
    field :last_name, :string
  end
end
