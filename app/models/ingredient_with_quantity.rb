class IngredientWithQuantity
  include Mongoid::Document
  
  field :quantity
  field :name

  embedded_in :recipe
end
