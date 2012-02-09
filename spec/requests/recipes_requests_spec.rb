require 'spec_helper'

describe "RecipesController" do
  describe "create new recipe" do
    it "should create a new recipe and redirect to new_user page" do
      lambda do
        visit new_recipe_path

        test_recipe = Factory.attributes_for(:recipe)

        fill_in "recipe_name", :with => test_recipe[:name]
        fill_in "recipe_portion", :with => test_recipe[:portion]
        fill_in "recipe_preparation", :with => test_recipe[:preparation]
        fill_in "recipe_duration", :with => test_recipe[:duration]
        fill_in "recipe_country", :with => test_recipe[:country]
        fill_in "recipe_city", :with => test_recipe[:city]
        page.find('#recipe_longitude').set(test_recipe[:longitude])
        page.find('#recipe_latitude').set(test_recipe[:latitude])

        click_button "Speichern"

        page.should have_selector(:user_female, :value => "Male")
        page.should have_selector(:user_female, :value => "Female")
      end.should change(Recipe, :count).by(1)
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