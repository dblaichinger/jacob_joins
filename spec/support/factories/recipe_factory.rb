Factory.define :ingredient_with_quantity do |f|
  f.quantity "100ml"
  f.name "Milch"
end

Factory.define :step do |f|
  f.description "lorem ipsum dolor und so weiter..."
end

Factory.define :recipe do |f|
  f.name "Kartoffelpuffer"
  f.portion 4
  f.duration 50
  f.city "Salzburg"
  f.country "Austria"
  f.latitude 47.812232
  f.longitude 13.055019
  f.steps {[Factory.build(:step)]}
  f.ingredients_with_quantities {[Factory.build(:ingredient_with_quantity, :name => "Milch1"), Factory.build(:ingredient_with_quantity, :name => "Milch2")]}
end
