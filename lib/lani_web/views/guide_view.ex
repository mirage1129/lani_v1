defmodule LaniWeb.GuideView do
  use LaniWeb, :view

  alias Lani.Events.Category

  def category_select_options(categories) do
		for category <- categories, do: {category.name, category.id}
	end


		
	# def category_options(categories) do
	# 	for category <- categories, do: {category.name}
	# end

end
