class IngredientWithQuantity
  include Mongoid::Document
  
  field :quantity

  has_one :ingredient
  embedded_in :recipe
end
