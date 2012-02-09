class RecipesController < ApplicationController
  include Geocoder::Model::Mongoid

  def index
    @recipes = Recipe.all
  end

	def new
		@recipe = Recipe.new
    
    #Get location by IP-address
    @location = request.location
	end

	def create
    @recipe = Recipe.new params[:recipe]
    
    if @recipe.save
      redirect_to new_recipe_user_path(@recipe.slug)
    else
      render new_recipe_path
    end
	end

  def show
    @recipe = Recipe.find_by_slug params[:id]
  end
end
