class PagesController < HighVoltage::PagesController
  layout :select_layout
  before_filter :prerequisite

  protected
  def select_layout
    case params[:id]
    when 'drafts_saved', 'preview'
      false
    else
      'application'
    end
  end

  def prerequisite
    case params[:id]
    when 'drafts_saved'
      if session[:user_id].present?
        user = User.find session[:user_id]
        recipe = Recipe.find session[:recipe_id] if session[:recipe_id].present?
        csi_set = CsiSet.find session[:csi_set_id] if session[:csi_set_id].present?

        UserMailer.thank_you_wizard(user, recipe, csi_set).deliver

        csi_set.destroy if csi_set.present?
        session[:user_id] = session[:location] = session[:recipe_id] = session[:csi_set_id] = nil
      end
    when 'preview'
      @recipe = Recipe.find session[:recipe_id] if session[:recipe_id].present?
      @csi_set = CsiSet.find session[:csi_set_id] if session[:csi_set_id].present?
      @answered_csis = @csi_set.country_specific_informations.where(:answer.ne => "").entries if @csi_set
    end
  end
end
