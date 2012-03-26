require 'spec_helper'

describe CsiSet do
  describe "publish" do
    it "should save csis and suicide" do
      csi_set = FactoryGirl.create :csi_set
      csi_set.publish

      CsiSet.all.count.should == 0
      CountrySpecificInformation.first.state.should == "published"
    end
  end
end
