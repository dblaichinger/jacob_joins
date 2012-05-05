require 'spec_helper'

describe CountrySpecificInformation do
  describe "state machine" do
    it "should save empty as draft" do
      csi = CountrySpecificInformation.new
      csi.save.should == true
      csi.state.should == "draft"
    end

    it "should not change to state published if validations fail" do
      csi = CountrySpecificInformation.new
      csi.publish.should == false
    end

    it "should change to state published if validations succeed" do
      csi = FactoryGirl.build :country_specific_information
      csi.publish.should == true
    end
  end
end
