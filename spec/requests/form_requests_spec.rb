require 'spec_helper'

describe "form submit" do
  it "shows a preview and creates recipe, user and csis" do
    recipe = FactoryGirl.build :recipe
    csi_set = FactoryGirl.build :csi_set
    user = FactoryGirl.build :user

    visit root_path

    within '#recipe_tab' do
      fill_in "recipe_name", :with => recipe.name
      fill_in "recipe_portions", :with => recipe.portions
      fill_in "recipe_duration", :with => recipe.duration

      recipe.ingredients_with_quantities.each_with_index do |iwq, index| 
        fill_in "recipe_ingredients_with_quantities_attributes_#{index}_quantity", :with => iwq.quantity
        fill_in "recipe_ingredients_with_quantities_attributes_#{index}_name", :with => iwq.name
      end
      
      recipe.steps.each_with_index do |step, index|
        fill_in "recipe_steps_attributes_#{index}_description", :with => step.description
      end

      attach_file "recipe_steps_attributes_0_image", "spec/files/test_image.png"
      page.should have_css('.steps .step .image_preview')

      # TODO: "add test case for recipe image upload" # was not working, test.log showed unfinished controller action
      attach_file "recipe_images_attributes_0_attachment", "spec/files/test_image.png"
      page.should have_css('#recipe_images ul.file_uploads li', :count => 1)

      sleep 1
    end

    click_link "About your country"

    within '#country_specific_information_tab' do
      fill_in "csi_set_country_specific_informations_attributes_0_answer", :with => csi_set.country_specific_informations.first.answer
      click_link "2"
      fill_in "csi_set_country_specific_informations_attributes_1_answer", :with => csi_set.country_specific_informations.last.answer
    end

    click_link "About you"

    within '#user_tab' do
      fill_in "user_firstname", :with => user.firstname
      fill_in "user_lastname", :with => user.lastname
      click_link user.gender + "_link"
      fill_in "user_age", :with => user.age
      fill_in "user_email", :with => user.email
      select user.heard_from, :from => "user_heard_from"
      fill_in "country", :with => recipe.country
      fill_in "city", :with => recipe.city
      page.find('#latitude').set(recipe.latitude)
      page.find('#longitude').set(recipe.longitude)
    end

    click_link 'preview'

    within '#preview_tab' do
      within '.recipe' do
        page.should have_css('h1', :text => recipe.name.upcase)
        page.should have_content(recipe.portions)
        page.should have_content(recipe.duration)

        recipe.ingredients_with_quantities.each do |iwq|
          page.should have_content(iwq.quantity)
          page.should have_content(iwq.name)
        end

        recipe.steps.each do |step| 
          page.should have_content(step.description)
          # TODO: "test step images if markup is affixed"
        end
      end

      within '.csi' do
        csi_set.country_specific_informations.each do |csi|
          page.should have_content(csi.question)
          page.should have_content(csi.answer)
        end
      end

      # TODO: test user if markup is available
      #within '.user' do
      #end

      click_button "Finish and Send"
      #binding.pry
      page.should have_css('p.success', :text => "Saved successfully")
    end
  end
end