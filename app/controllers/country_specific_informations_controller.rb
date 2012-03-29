class CountrySpecificInformationsController < ApplicationController
  def show
    render :status => 410, :text => "Gone" and return unless session[:csi_set_id]
    
    @csi_set = CsiSet.find session[:csi_set_id]
    render :layout => false
  end

  def update
    render :status => 410, :text => "Gone" and return unless session[:csi_set_id]
    render :status => 400, :text => "Bad Request" and return unless params[:user_id] && params[:location]
    
    csi_set = CsiSet.find session[:csi_set_id]
    user = User.find params[:user_id]

    csi_set.latitude = params[:location][:latitude]
    csi_set.longitude = params[:location][:longitude]
    csi_set.city = params[:location][:city]
    csi_set.country = params[:location][:country]

    if csi_set.publish
      session[:csi_set_id] = nil
      render :new, :layout => false
    else
      render :status => 400, :text => "Bad Request"
    end
  end

  def sync_wizard
    if session[:csi_set_id].present?
      @csi_set = CsiSet.find session[:csi_set_id]
    else
      @csi_set = CsiSet.create
      session[:csi_set_id] = @csi_set.id
    end
    
    if @csi_set.update_attributes params[:csi_set]
      render :new, :layout => false
    else
      render :status => 400, :text => 'Bad Request'
    end
  end
end
