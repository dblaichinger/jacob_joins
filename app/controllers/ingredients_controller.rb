class IngredientsController < ApplicationController
  def names
    render :json => Ingredient.names_with(params[:term]).to_json
  end
end
