require 'spec_helper'

describe CountrySpecificInformationsController do
  describe "sync_wizard" do
    it "should sync csi data on tab switch" do
      csi_set = FactoryGirl.create :csi_set

      visit root_path
      click_link 'About your country'
      fill_in "csi_set_country_specific_informations_attributes_0_answer", :with => csi_set.country_specific_informations.first.answer
      click_link 'preview'

      page.should have_css('#preview_tab h3', :text => csi_set.country_specific_informations.first.question)
      page.should have_content(csi_set.country_specific_informations.first.answer)
    end
  end
end