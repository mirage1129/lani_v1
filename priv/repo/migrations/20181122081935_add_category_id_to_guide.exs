defmodule Lani.Repo.Migrations.AddCategoryIdToGuide do
  use Ecto.Migration

  def change do
  	alter table(:guides) do
			add :category_id, references(:categories)
		end
  end
end
