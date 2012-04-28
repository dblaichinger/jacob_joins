class PagesController < HighVoltage::PagesController
  layout :select_layout
  before_filter :prepare_variables

  protected
  def select_layout
    case params[:id]
    when 'drafts_saved', 'preview'
      false
    else
      'application'
    end
  end

  def prepare_variables
    case params[:id]
    when 'preview'
      @recipe = Recipe.find session[:recipe_id] if session[:recipe_id].present?
      @csi_set = CsiSet.find session[:csi_set_id] if session[:csi_set_id].present?
      @answered_csis = @csi_set.country_specific_informations.where(:answer.ne => "").entries if @csi_set
    end
  end
end
