class UsersController < ApplicationController

def new
  @user = User.new
end

def create

  @user = User.new params[:user]

  #raise params[:user].inspect
  if @user.save
    @recipe = Recipe.find_by_slug(params[:recipe_id])
    @recipe.user_id = @user.id
    @recipe.save!
    redirect_to recipe_path(params[:recipe_id])
  else
    redirect_to new_recipe_user_path(params[:recipe_id])
  end
end

end
