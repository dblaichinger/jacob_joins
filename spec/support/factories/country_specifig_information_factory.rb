require 'factory_girl'

FactoryGirl.define do
  factory :country_specific_information do |f|
    f.question "How is the weather?"
    f.answer "Cloudy with a Chance of Meatballs."
    f.city "Salzburg"
    f.country "Austria"
    f.latitude 47.812232
    f.longitude 13.055019
    f.association :question_reference, :factory => :question
  end
end