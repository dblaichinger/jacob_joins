require 'spec_helper'

describe UsersController do
  describe "create new user" do
    it "should create a new user and redirect to recipe#show" do
      lambda do

        test_recipe = Factory(:recipe)
        test_user = Factory.attributes_for(:user)

        visit new_recipe_user_path(test_recipe)

        fill_in "user_name", :with => test_user[:name]
        select "Male", :from => "user_gender"
        fill_in "user_age", :with => test_user[:age]
        fill_in "user_email", :with => test_user[:email]
        choose "user_heard_from_internet"

        click_button "Speichern"

        page.should have_selector( "p", :text => "Kartoffelpuffer")
      end.should change(User, :count).by(1)
    end
  end
end