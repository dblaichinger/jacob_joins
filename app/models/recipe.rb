class Recipe
  include Mongoid::Document
  include Mongoid::Slug


  field :name, :type => String
  field :portion, :type => Integer
  field :preparation, :type => String
  field :duration, :type => Integer
  field :unique_name, :type => String

  belongs_to :user
  embeds_many :ingredients_with_quantities

  attr_accessible :name, :portion, :preparation, :duration, :ingredients
  attr_accessor :ingredients

  before_save :extract_ingredients

  slug :name

  def extract_ingredients
    self.ingredients.select! { |i| !i.empty?}
    self.ingredients_with_quantities = []
    self.ingredients.each do |i|
      self.ingredients_with_quantities << IngredientWithQuantity.new(:quantity => i)
    end
  end
end
