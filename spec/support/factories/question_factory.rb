FactoryGirl.define do
  factory :question do |f|
    f.text "How is the weather?"
  end

  factory :another_question, :class => "Question" do |f|
    f.text "How large is your country?"
  end
end