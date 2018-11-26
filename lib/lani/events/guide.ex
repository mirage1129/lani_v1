defmodule Lani.Events.Guide do
  use Ecto.Schema
  import Ecto.Changeset


  schema "guides" do
    field :bring, :string
    field :cost, :string
    field :description, :string
    field :image_url, :string
    field :intensity, :string
    field :map_link, :string
    field :name, :string
    field :starting_location, :string

    belongs_to :category, Lani.Events.Category

    timestamps()
  end

  @doc false
  def changeset(guide, attrs) do
    guide
    |> cast(attrs, [:name, :description, :starting_location, :image_url, :cost, :bring, :intensity, :map_link, :category_id])
    |> validate_required([:name, :description, :starting_location, :image_url, :cost, :bring, :intensity, :map_link])
  end
  
end
