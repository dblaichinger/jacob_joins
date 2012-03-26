require 'spec_helper'

describe CountrySpecificInformationsController do
  describe "sync_wizard", :type => :request, :js => true, :driver => :webkit do
    it "should sync csi data on tab switch" do
      lambda do
        csi_set = FactoryGirl.create :csi_set

        visit '/'
        click_link 'About your country'
        fill_in "csi_set_country_specific_informations_attributes_0_answer", :with => csi_set.country_specific_informations.first.answer
        click_link 'About you'
      end.should change(CountrySpecificInformation, :count).by(1)
    end
  end
end