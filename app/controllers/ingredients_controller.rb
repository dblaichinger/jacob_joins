class IngredientsController < ApplicationController
  #respond_to :html, :json

  def names
    render :json => Ingredient.names_with(params[:term]).to_json
  end

  def search
    respond_to do |format|
      format.json {
        #raise params.inspect
        @ingredients = []
        params[:ingredients].each do |key, value|
          query = Ingredient.search_by_name(value)
          @ingredients << query.entries
        end
        @ingredients = @ingredients.flatten

        binding.pry
        counter = 0
        if @ingredient.length > 0
          while counter <= @ingredients.length-1
            ingredient = @ingredients[counter]
            ingredient.recipe_ids.each do |id|
              ingredient[counter] = 
          end
        end

        
        
        #todo: order the recipes and find the first 10? from the ordered array
        @recipes = []
        @ingredients.each do |ingredient|
          @recipes << Recipe.find(ingredient.recipe_ids[0])
        end
        render :json => {:ingredients => @ingredients, :recipes => @recipes}
      }
      format.html
    end
  end
end
