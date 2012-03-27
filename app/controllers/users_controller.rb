class UsersController < ApplicationController
  include Geocoder::Model::Mongoid

  before_filter :get_or_create_user, :only => [:sync_wizard]

  def update
    render :status => 400, :text => "Bad Request" and return unless session[:user_id]

    user = User.find session[:user_id]
    render :status => 304, :text => "Not Modified" and return if user.published?

    if user.publish
      render :json => { user_id: session[:user_id], location: session[:location] }.to_json
      session[:user_id] = session[:location] = nil
    else
      render :status => 400, :text => "Bad Request"
    end
  end

  def sync_wizard
    if(params[:longitude] && params[:latitude] && params[:city] && params[:country])
      session[:location] = { :longitude => params[:longitude], :latitude => params[:latitude], :city => params[:city], :country => params[:country] }
    end

    if @user.update_attributes params[:user]
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
end
