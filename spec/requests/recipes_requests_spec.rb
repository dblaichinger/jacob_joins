require 'spec_helper'

describe "RecipesController" do
  describe "create new recipe" do
    it "should create a new recipe and redirect to index page" do
      visit new_recipe_path

      test_recipe = Factory(:recipe)

      fill_in "recipe_name", :with => test_recipe.name
      fill_in "recipe_portion", :with => test_recipe.portion
      fill_in "recipe_preparation", :with => test_recipe.preparation
      fill_in "recipe_duration", :with => test_recipe.duration

      click_button "Speichern"

      page.should have_selector "ul li", :text => test_recipe.name
    end
  end

  describe "show" do
   it "should be accessible through slug" do
    recipe = Recipe.create! Factory.attributes_for(:recipe)
    recipe1 = Recipe.create! Factory.attributes_for(:recipe)

    visit recipe_path(recipe1)

    page.should have_selector "p", :text => recipe1.slug
   end
  end
end