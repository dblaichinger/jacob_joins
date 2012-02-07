class RecipesController < ApplicationController

  def index
    @recipes = Recipe.all
  end

	def new
		@recipe = Recipe.new
	end

	def create
    @recipe = Recipe.new params[:recipe]
    if @recipe.save
      redirect_to recipes_path
    else
      render new_recipe_path
    end
	end

  def show
    @recipe = Recipe.find_by_slug params[:id]
  end
end
