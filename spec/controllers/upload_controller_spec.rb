require 'spec_helper'

describe UploadController do

  describe "GET 'upload/recipe'" do
    it "should be successful" do
      get 'recipe'
      response.should be_success
    end
  end

  describe "GET 'upload/user'" do
    it "should be successful" do
      get 'user'
      response.should be_success
    end
  end

end
