#encoding: utf-8

require 'spec_helper'

describe "Recipes" do
  describe "slug" do
    it "should save url friendly name" do
      recipe = Recipe.create!(Factory.attributes_for(:recipe, :name => "äö ü@-,"))
      recipe.slug.should == "ao-u-at"
    end

    it "should concat a number to the slug" do
      recipe = Recipe.create!(Factory.attributes_for(:recipe))
      recipe1 = Recipe.create!(Factory.attributes_for(:recipe))

      recipe1.slug.should == "#{recipe.slug}-1"
    end
  end

  describe "ingredients" do
    it "should save ingredients and ingredients_with_quantities from ingredients_strings" do
      recipe = Recipe.new Factory.attributes_for(:recipe)
      recipe.ingredients_strings = [{"quantity" => "100ml", "ingredient" => "Milch"}, {"quantity" => "1 kg", "ingredient" => "Kartoffel"}]
      recipe.save

      recipe.ingredients.to_a.count.should == 2
      recipe.ingredients_with_quantities.count.should == 2

      recipe.ingredients.first.name.should == recipe.ingredients_strings[0][:ingredient]
      recipe.ingredients.last.name.should == recipe.ingredients_strings[1][:ingredient]

      recipe.ingredients_with_quantities.first.quantity.should == recipe.ingredients_strings[0][:quantity]
      recipe.ingredients_with_quantities.first.name.should == recipe.ingredients_strings[0][:ingredient]

      recipe.ingredients_with_quantities.last.quantity.should == recipe.ingredients_strings[1][:quantity]
      recipe.ingredients_with_quantities.last.name.should == recipe.ingredients_strings[1][:ingredient]
    end
  end
end