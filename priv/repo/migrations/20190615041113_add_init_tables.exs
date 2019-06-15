defmodule UnboardQl.Repo.Migrations.AddInitTables do
  use Ecto.Migration

  def change do
    create table("location") do
      add :name, :string
      add :address1, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :lat, :decimal
      add :long, :decimal

      timestamps()
    end

    create table("activity_type") do
      add :name, :string

      timestamps()
    end

    create table("activity") do
      add :activity_type_id, :integer
      add :name, :string
      add :description, :string
      add :image_url, :string
      add :participant_capacity, :integer
      add :registered_participants, :integer
      add :price, :float
      add :accessibility, :float
      add :start_time, :integer
      add :end_time, :integer
      add :creator_id, :integer
      add :location_id, :integer
      add :sponsored, :boolean
      add :link, :string
      add :type_id, :integer

      timestamps()
    end

    create table("user") do
      add :email, :string
      add :password, :string
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end

    create table("activity_paricipant") do
      add :activity_id, :integer
      add :user_id, :integer

      timestamps()
    end

    create table("activity_like") do
      add :activity_id, :integer
      add :user_id, :integer

      timestamps()
    end

    create table("activity_comment") do
      add :activity_id, :integer
      add :user_id, :integer
      add :content, :string

      timestamps()
    end

    create table("activity_rating") do
      add :activity_id, :integer
      add :user_id, :integer
      add :rating, :integer, size: 1

      timestamps()
    end

    create table("activity_impression") do
      add :activity_id, :integer
      add :user_id, :integer

      timestamps()
    end

    flush()

    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "diy"})
    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "recreational"})
    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "cooking"})
    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "charity"})
    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "relaxation"})
    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "social"})
    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "outdoors"})
    UnboardQl.Repo.insert(%UnboardQl.ActivityType{name: "indoors"})

    UnboardQl.Repo.insert(%UnboardQl.User{email: "brennan3@gmail.com", password: "1234", first_name: "Mike", last_name: "Brennan"})

    UnboardQl.Repo.insert(%UnboardQl.Location{name: "Dig Buffalo", address1: "640 Ellicott St", city: "Buffalo", state: "NY", zip: "14203"})

    UnboardQl.Repo.insert(%UnboardQl.Activity{name: "Code Buffalo", description: "Awesome Hackathon!!", location_id: 1, start_time: 1560551400, end_time: 1560706200, sponsored: true, accessibility: 0.3, price: 0.0, participant_capacity: 250, link: "https://www.43north.org/events/codebuffalo/", creator_id: 1})
  end
end
