require 'spec_helper'

describe RecipesController do
  describe "sync_wizard" do
    it "should sync recipe data on tab switch" do
      recipe = FactoryGirl.build :recipe

      visit root_path
      fill_in "recipe_name", :with => recipe.name
      click_link 'preview'

      page.should have_css('#preview_tab h1', :text => recipe.name.upcase)
    end
  end
end