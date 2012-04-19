class IngredientsController < ApplicationController
  #respond_to :html, :json

  def names
    render :json => Ingredient.names_with(params[:term]).to_json
  end

  def search
    @ingredients = Ingredient.search params[:search]
    respond_to do |format|
      format.html { render ingredients_search_path, :locals => {:ingredients => @ingredients || nil}}
      format.json { render ingredients_search_path, :locals => {:ingredients => @ingredients}, :layout => false}
    end
  end
end
