class PagesController < HighVoltage::PagesController
  layout 'application'

  def preview
    @recipe = Recipe.find session[:recipe_id] if session[:recipe_id].present?
    @csi_set = CsiSet.find session[:csi_set_id] if session[:csi_set_id].present?
    @answered_csis = @csi_set.country_specific_informations.where(:answer.ne => "").entries if @csi_set

    render 'preview', :layout => false
  end

  def drafts_saved
    if session[:user_id].present?
      @user = User.find session[:user_id]
      @recipe = Recipe.find session[:recipe_id] if session[:recipe_id].present?
      @csi_set = CsiSet.find session[:csi_set_id] if session[:csi_set_id].present?

      UserMailer.thank_you_wizard(@user, @recipe, @csi_set).deliver if @user.email.present?

      @csi_set.destroy if @csi_set.present?
      session[:user_id] = session[:location] = session[:recipe_id] = session[:csi_set_id] = nil

      render 'drafts_saved', :layout => false
    else
      render :status => 400, :text => "Bad Request."
    end
  end

  def fb_channel
    render 'fb_channel', :layout => false
  end
end
