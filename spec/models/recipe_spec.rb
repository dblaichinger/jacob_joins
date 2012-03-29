#encoding: utf-8

require 'spec_helper'

describe Recipe do
  it "should save ingredients and ingredients_with_quantities" do
    recipe = Recipe.create FactoryGirl.attributes_for(:recipe)

    recipe.ingredients_with_quantities.count.should == 2
    recipe.ingredients_with_quantities.first.quantity.should == "100ml"
    recipe.ingredients_with_quantities.first.name.should == "Milch1"

    recipe.ingredients.count.should == 2
    recipe.ingredients.first.name.should == recipe.ingredients_with_quantities.first.name
    recipe.ingredients.last.name.should == recipe.ingredients_with_quantities.last.name
  end

  describe "slug" do
    it "should save url friendly name" do
      recipe = Recipe.create!(FactoryGirl.attributes_for(:recipe, :name => "äö ü@-,"))
      recipe.slug.should == "ao-u-at"
    end

    it "should concat a number to the slug" do
      recipe = Recipe.create!(FactoryGirl.attributes_for(:recipe))
      recipe1 = Recipe.create!(FactoryGirl.attributes_for(:recipe))

      recipe1.slug.should == "#{recipe.slug}-1"
    end
  end

  describe "state machine" do
    before :each do
      @recipe = Recipe.new FactoryGirl.attributes_for(:recipe)
    end

    it "should save empty as draft" do
      @recipe.save.should == true
      @recipe.state.should == "draft"
    end

    it "should not change to state published if validations fail" do
      @recipe.name = ""
      @recipe.save!
      @recipe.publish.should == false
    end

    it "should change to state published if validations succeed" do
      @recipe.publish.should == true
    end
  end
end