class UsersController < ApplicationController
include Geocoder::Model::Mongoid

def new
  @user = User.new
end

def create
  #raise params.inspect
  @user = User.new(params[:user])

  if @user.save
    cookies[:jacob_joins_user] = { :value => @user.id, :expires => 20.years.from_now.utc }
    if cookies[:jacob_joins_recipe].present?
      @recipe = Recipe.find(cookies[:jacob_joins_recipe])
      @recipe.user_id = @user.id
      @recipe.save!
    end
    if cookies[:jacob_joins_recipe].present? || cookies[:jacob_joins_csi].present?
      redirect_to show_preview_upload_index_path
    else 
      flash[:error] = "Please provide at least one recipe or country information!"
      redirect_to user_upload_index_path
    end
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

def find_user
  @user = User.find(params[:id])

  respond_to do |format|  
    format.json { render :json => @user.to_json }
  end
end

end
