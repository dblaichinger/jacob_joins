require 'spec_helper'

describe "RecipesController" do
  describe "create" do
    it "should create a new recipe with ingredients and quantity and redirect to index page" do
      visit new_recipe_path

      test_recipe = Factory(:recipe)

      fill_in "recipe_name", :with => test_recipe.name
      fill_in "recipe_portion", :with => test_recipe.portion
      fill_in "recipe_preparation", :with => test_recipe.preparation
      fill_in "recipe_duration", :with => test_recipe.duration

      fill_in "recipe_ingredients_strings__quantity1", :with => test_recipe.ingredients_with_quantities[0].quantity
      fill_in "recipe_ingredients_strings__ingredient1", :with => test_recipe.ingredients_with_quantities[0].name
      fill_in "recipe_ingredients_strings__quantity2", :with => test_recipe.ingredients_with_quantities[1].quantity
      fill_in "recipe_ingredients_strings__ingredient2", :with => test_recipe.ingredients_with_quantities[1].name

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