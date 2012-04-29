class UsersController < ApplicationController
  include Geocoder::Model::Mongoid

  before_filter :get_or_create_user, :only => :sync_wizard
  append_before_filter :check_user_id_presence, :already_published?, :only => :update
  before_filter :save_recipe, :only => :sync_wizard, :if => lambda{ session[:recipe_id].present? }
  before_filter :save_csi_set, :only => :sync_wizard, :if => lambda{ session[:csi_set_id].present? }

  def update
    if @user.publish
      render :new, :layout => false
    else
      render :status => 400, :text => "Bad Request"
    end
  end

  def sync_wizard
    if(params[:longitude] && params[:latitude] && params[:city] && params[:country])
      session[:location] = { :longitude => params[:longitude], :latitude => params[:latitude], :city => params[:city], :country => params[:country] }
    end

    if @user.update_attributes params[:user]
      @user.update_attribute :heard_from, params[:heard_from_other] if params[:heard_from_other] && params[:user][:heard_from] == "other"
      render :new, :layout => false
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  def find_user
    @user = User.find params[:id]

    respond_to do |format|  
      format.json{ render :json => @user.to_json }
    end
  end

  private
  def get_or_create_user
    if session[:user_id].present?
      @user = User.find session[:user_id]
    else
      @user = User.create
      session[:user_id] = @user.id
    end
  end

  def save_recipe
    recipe = Recipe.criteria.for_ids(session[:recipe_id]).entries.first
    @user.recipe = recipe if recipe
  end

  def save_csi_set
    csi_set = CsiSet.criteria.for_ids(session[:csi_set_id]).entries.first
    user = User.find session[:user_id]
    csi_set.user =  user
  end

  def check_user_id_presence
    render :status => 400, :text => "Bad Request" and return unless session[:user_id].present?
  end

  def already_published?
    @user = User.find session[:user_id]
    render :status => 304, :text => "Not Modified" and return if @user.published?
  end
end
