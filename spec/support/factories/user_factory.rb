FactoryGirl.define do
  factory :user do |f|
    f.firstname "Sheldon"
    f.lastname "Cooper"
    f.email "sheldon@cooper.com"
    f.age 28
    f.heard_from "Internet"
    f.gender "male"
  end
end