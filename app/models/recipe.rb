class Recipe
  include Mongoid::Document
  include Mongoid::Slug

  field :name, :type => String
  field :portion, :type => Integer
  field :preparation, :type => String
  field :duration, :type => Integer
  field :city, :type => String
  field :country, :type => String
  field :latitude, :type => Float
  field :longitude, :type => Float

  belongs_to :user
  has_and_belongs_to_many :ingredients
  embeds_many :ingredients_with_quantities

  attr_accessible :name, :portion, :preparation, :duration, :ingredients_strings, :city, :country, :latitude, :longitude
  attr_accessor :ingredients_strings
  validates_presence_of :name, :portion, :preparation, :duration, :city, :country, :latitude, :longitude

  before_save :extract_ingredients
  slug :name

  protected
  def extract_ingredients
    if !self.ingredients_strings.nil?
      self.ingredients = []
      self.ingredients_with_quantities = []

      self.ingredients_strings.each do |i|
        break if i[:quantity] == "" && i[:ingredient] == ""
        self.ingredients << Ingredient.find_or_create_by(:name => i[:ingredient])
        self.ingredients_with_quantities << IngredientWithQuantity.new(:quantity => i[:quantity], :name => i[:ingredient])
      end
    end
  end
end
