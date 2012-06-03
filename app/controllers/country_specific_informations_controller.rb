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
    @csi_set = CsiSet.find session[:csi_set_id]
    user = User.find params[:user_id]
    
    @csi_set.country_specific_informations.map { |csi| csi.update_attributes(params[:location]) && (csi.user = user) && csi.save }

    if @csi_set.publish
      @csi_set = CsiSet.new :country_specific_informations => CsiSet.empty_set
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
      @csi_set.country_specific_informations.each { |csi| csi.question_reference.update_country_specific_informations }
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
