require 'spec_helper'

describe UsersController do
  describe "create new user" do
    it "should create a new user and redirect to recipe#show" do
      lambda do

        #test_recipe = Factory(:recipe)
        test_user = Factory.attributes_for(:user)

        visit user_upload_index_path

        fill_in "user_name", :with => test_user[:name]
        select "Male", :from => "user_gender"
        fill_in "user_age", :with => test_user[:age]
        fill_in "user_email", :with => test_user[:email]
        choose "user_heard_from_internet"

        click_button "Save"
        page.should have_selector( "p", :text => "Sheldon Cooper")
      end.should change(User, :count).by(1)
    end

    it "should not create a new user if the validation of the data fails" do
      lambda do
        #test_recipe = Factory(:recipe)
        test_user = Factory.attributes_for(:user)

        visit user_upload_index_path

        fill_in "user_name", :with => ""
        select "Male", :from => "user_gender"
        fill_in "user_age", :with => ""
        fill_in "user_email", :with => test_user[:email]
        choose "user_heard_from_internet"

        click_button "Save"

        page.should have_selector("li", :text => "Name can't be blank")
        page.should have_selector("li", :text => "Age can't be blank")
        page.should have_selector("div", :class => "field_with_errors")
      end.should change(User, :count).by(0)
    end
  end
end