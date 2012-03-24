FactoryGirl.define do
  factory :user do |f|
    f.name "Sheldon Cooper"
    f.email "sheldon@cooper.com"
    f.age 28
    f.heard_from "Internet"
    f.gender "male"
  end
end