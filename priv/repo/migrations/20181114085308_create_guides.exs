defmodule Lani.Repo.Migrations.CreateGuides do
  use Ecto.Migration

  def change do
    create table(:guides) do
      add :name, :string
      add :description, :text
      add :starting_location, :string
      add :image_url, :string
      add :cost, :string
      add :bring, :string
      add :intensity, :string
      add :map_link, :string

      timestamps()
    end

  end
end
