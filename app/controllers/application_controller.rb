class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def check_for_user_and_location
    render :status => 400, :text => "Bad Request" and return unless params[:user_id].present? && params[:location].present?
  end
end
