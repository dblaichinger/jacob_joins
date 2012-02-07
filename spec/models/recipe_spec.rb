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
end