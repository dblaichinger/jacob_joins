FactoryGirl.define do
  factory :csi_set do |csi_set|
    csi_set.country_specific_informations {
      [ FactoryGirl.build(:country_specific_information) ]
    }    
  end
end