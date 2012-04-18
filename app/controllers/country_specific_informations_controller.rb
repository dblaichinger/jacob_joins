class CountrySpecificInformationsController < ApplicationController
  append_before_filter :check_csi_set_id_presence, :check_for_user_and_location, :only => :update
  before_filter :check_csi_set_id_presence, :only => :show

  def show
    @csi_set = CsiSet.find session[:csi_set_id]
    answered_csis = @csi_set.country_specific_informations.where(:answer.ne => "").entries

    if answered_csis.count > 0
      render :show, :layout => false
    else
      render :partial => "no_preview", :layout => false
    end
  end

  def update
    csi_set = CsiSet.find session[:csi_set_id]
    user = User.find params[:user_id]

    csi_set.latitude = params[:location][:latitude]
    csi_set.longitude = params[:location][:longitude]
    csi_set.city = params[:location][:city]
    csi_set.country = params[:location][:country]
    csi_set.user = user

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

    params[:csi_set][:country_specific_informations_attributes].each{ |key,csi| csi[:answer] = "" if csi[:answer] == " " }
    
    if @csi_set.update_attributes params[:csi_set]
      render :new, :layout => false
    else
      render :status => 400, :text => 'Bad Request'
    end
  end

  private
  def check_csi_set_id_presence
    render :status => 410, :text => "Gone" and return unless session[:csi_set_id].present?
  end
end
