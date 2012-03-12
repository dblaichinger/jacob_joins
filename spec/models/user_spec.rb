require 'spec_helper'

describe User do
  describe "state machine" do
    it "should save empty as draft" do
      user = User.new
      user.save.should == true
      user.state.should == "draft"
    end

    it "should not change to state published if validations fail" do
      user = User.new
      user.publish.should == false
    end

    it "should change to state published if validations succeed" do
      user = FactoryGirl.build :user
      user.publish.should == true
    end
  end
end
