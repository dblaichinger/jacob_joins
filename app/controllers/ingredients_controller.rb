class IngredientsController < ApplicationController
  #respond_to :html, :json

  def names
    render :json => Ingredient.names_with(params[:term]).to_json
  end

  def search
    @ingredients = Ingredient.search params[:search]
    respond_to do |format|
      format.json {render :json => @ingredients.to_json}
      format.html
    end
  end
end
