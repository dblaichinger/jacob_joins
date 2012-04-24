class PagesController < HighVoltage::PagesController
  layout :select_layout

  protected
  def select_layout
    case params[:id]
    when 'drafts_saved'
      false
    else
      'application'
    end
  end
end
