class IngredientsController < ApplicationController
  def names
  	if params[:term].present?
      render :json => Ingredient.names_with(params[:term]).to_json
    else
      render :status => 400, :text => 'Bad Request'
    end
  end
end
