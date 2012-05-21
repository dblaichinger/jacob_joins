class FeedbackController < ApplicationController
  before_filter :min_info_provided?, :authenticity_token_valid?

  def create
    user = { :name => params[:name], :email => params[:email] }
    FeedbackMailer.user_feedback(user, params[:subject], params[:message]).deliver
    render :json => { :status => 200 }
  end

  private

  def min_info_provided?
    head :bad_request unless params[:email] && params[:message]
  end

  def authenticity_token_valid?
    head :bad_request unless params[:authenticity_token] == session[:_csrf_token]
  end
end
