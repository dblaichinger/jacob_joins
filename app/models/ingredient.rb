class Ingredient
  include Mongoid::Document
  field :name, :type => String

  has_and_belongs_to_many :recipes
  belongs_to :ingredient_with_quantity
end
