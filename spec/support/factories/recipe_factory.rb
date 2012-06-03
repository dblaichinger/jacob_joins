FactoryGirl.define do
  factory :ingredient_with_quantity do |f|
    f.quantity "100ml"
    f.name "Milch"
  end
end

FactoryGirl.define do
  factory :step do |f|
    f.description "lorem ipsum dolor und so weiter..."
  end

  factory :another_step, :class => "Step" do |f|
    f.description "another step description..." 
  end
end

FactoryGirl.define do
  factory :recipe do |f|
    f.name "Kartoffelpuffer"
    f.portions 4
    f.duration 50
    f.city "Salzburg"
    f.country "Austria"
    f.latitude 47.812232
    f.longitude 13.055019
    f.steps {[FactoryGirl.build(:step)]}
    f.ingredients_with_quantities {[FactoryGirl.build(:ingredient_with_quantity, :name => "Milch1"), FactoryGirl.build(:ingredient_with_quantity, :name => "Milch2")]}
  end
end
