class UsersController < ApplicationController

def new
  @user = User.new
end

def create
  @user = User.new(params[:user])

  if @user.save
    cookies[:jacob_joins_user] = { :value => @user.id, :expires => 20.years.from_now.utc }
    if cookies[:jacob_joins_recipe].present?
      @recipe = Recipe.find(cookies[:jacob_joins_recipe])
      @recipe.user_id = @user.id
      @recipe.save!
    end
    redirect_to show_preview_upload_index_path
  else
    session[:error] = @user
    redirect_to user_upload_index_path
  end
end


def update
  @user = User.find(params[:id])

  if @user.update_attributes(params[:user])
    cookies[:jacob_joins_user] = { :value => @user.id, :expires => 20.years.from_now.utc } unless cookies[:jacob_joins_user].present?
    if cookies[:jacob_joins_recipe].present?
      @recipe = Recipe.find(cookies[:jacob_joins_recipe])
      @recipe.user_id = @user.id
      @recipe.save!
    end
    redirect_to show_preview_upload_index_path
  else
    session[:error] = @user
    redirect_to user_upload_index_path
  end
end

end
