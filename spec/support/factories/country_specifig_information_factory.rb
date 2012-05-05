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
  factory :another_country_specific_information, :class => "CountrySpecificInformation" do |f|
    f.question "How large is your country?"
    f.answer "Veeeeeery BIG!"
    f.city "Berlin"
    f.country "Germany"
    f.latitude 52.0
    f.longitude 13.0
    f.association :question_reference, :factory => :another_question
  end
end