class CountrySpecificInformationsController < ApplicationController
  def new
    @country_specific_informations = CountrySpecificInformation.new_set
  end

  def create
    @csis = CountrySpecificInformation.save_new_set params[:country_specific_informations]
    unless @csis.blank?
      cookies[:jacob_joins_csi] = { :value => "", :expires => 20.years.from_now.utc }
      
      @csis.each do |csi|
        cookies[:jacob_joins_csi] << "#{csi.id.to_s},"
      end

      if cookies[:jacob_joins_user].present?
        @user = User.find(cookies[:jacob_joins_user])
        @csis.each do |csi|
          csi.user_id = @user.id
          csi.save!
        end
      end
      redirect_to user_upload_index_path
    else
      session[:error] = @csis
      redirect_to country_specific_information_upload_index_path
    end

  end

  def update
    @country_specific_information = CountrySpecificInformation.find_by_id(params[:id])

    if @country_specific_information.update_attributes(params[:country_specific_information])
      cookies[:jacob_joins_csi] = { :value => @country_specific_information.id, :expires => 20.years.from_now.utc } unless cookies[:jacob_joins_user].present?
      if cookies[:jacob_joins_user].present?
        @user = User.find(cookies[:jacob_joins_user])
        @country_specific_information.user_id = @user.id
        @country_specific_information.save!
      end
      redirect_to user_upload_index_path
    else
      session[:error] = @country_specific_information
      redirect_to country_specific_information_upload_index_path
    end
  end
end
