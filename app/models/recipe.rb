class Recipe
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Paperclip

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

  embeds_many :steps, :cascade_callbacks => true
  accepts_nested_attributes_for :steps, :allow_destroy => true

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  attr_accessible :name, :portion, :duration, :ingredients_strings, :city, :country, :latitude, :longitude, :images, :images_attributes, :steps
  attr_accessor :ingredients_strings

  def valid_ingredients_strings
    if ingredients_strings
      ingredients_strings.reject{ |ingredient_string| ingredient_string[:quantity].blank? && ingredient_string[:ingredient].blank? }
    else
      nil
    end
  end
  

  before_save :extract_ingredients
  slug :name

  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    state :published do
      validates_presence_of :name, :portion, :duration, :city, :country, :latitude, :longitude
    end
  end

  protected
  def extract_ingredients
    unless self.ingredients_strings.nil?
      self.ingredients = []
      self.ingredients_with_quantities = []

      self.valid_ingredients_strings.each do |i|
        self.ingredients << Ingredient.find_or_create_by(:name => i[:ingredient])
        self.ingredients_with_quantities << IngredientWithQuantity.new(:quantity => i[:quantity], :name => i[:ingredient])
      end
    end
  end
end
