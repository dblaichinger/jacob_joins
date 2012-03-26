class UsersController < ApplicationController
include Geocoder::Model::Mongoid

before_filter :get_or_create_user, :only => [:sync_wizard]

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

def sync_wizard
  if(params[:longitude] && params[:latitude] && params[:city] && params[:country])
    session[:location] = [{"longitude" => params[:longitude], "latitude" => params[:latitude], "city" => params[:city], "country" => params[:country]}]
  end
  if @user.update_attributes params[:user]
    if params[:heard_from_other] && params[:user][:heard_from] == "other"
      @user.update_attribute(:heard_from, params[:heard_from_other])
    end
    render :new, :layout => false
  else
    render :status => 400, :text => 'Bad Request'
  end
end

def find_user
  @user = User.find(params[:id])

  respond_to do |format|  
    format.json { render :json => @user.to_json }
  end
end

protected
def get_or_create_user
  if session[:user_id].present?
    @user = User.find(session[:user_id])
  else
    @user = User.create
    session[:user_id] = @user.id
  end
end


end
