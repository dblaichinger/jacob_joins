require 'spec_helper'

describe PagesController do

  describe "GET 'show' with id 'drafts_saved'" do
    render_views
    
    it "should be successful" do
      user = FactoryGirl.create :user
      session[:user_id] = user.id
      recipe = FactoryGirl.create :recipe
      session[:recipe_id] = recipe.id

      get 'show', {:id => 'drafts_saved'}

      response.should render_template("user_mailer/thank_you_wizard")
      response.should render_template("pages/drafts_saved")
      ActionMailer::Base.deliveries.should_not be_empty
      session[:user_id].should be_nil
      session[:recipe_id].should be_nil
    end
  end

end
