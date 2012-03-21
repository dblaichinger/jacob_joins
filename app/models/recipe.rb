class Recipe
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Paperclip

  field :name, :type => String
  field :portion, :type => Integer
  field :duration, :type => Integer
  field :city, :type => String
  field :country, :type => String
  field :latitude, :type => Float
  field :longitude, :type => Float

  belongs_to :user

  has_and_belongs_to_many :ingredients

  embeds_many :ingredients_with_quantities

  embeds_many :steps, :validate => false, :cascade_callbacks => true
  accepts_nested_attributes_for :steps, :allow_destroy => true, :reject_if => :all_blank

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  attr_accessible :name, :portion, :duration, :ingredients_strings, :city, :country, :latitude, :longitude, :images, :images_attributes, :steps, :steps_attributes
  attr_accessor :ingredients_strings
  
  before_save :extract_ingredients
  slug :name

  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    state :published do
      validates_presence_of :name, :portion, :duration, :city, :country, :latitude, :longitude
      validates_associated :steps
    end
  end

  protected
  def extract_ingredients
    unless self.ingredients_strings.nil?
      self.ingredients = []
      self.ingredients_with_quantities = []

      self.ingredients_strings.each do |i|
       next if i[:quantity] == "" && i[:ingredient] == ""
        self.ingredients << Ingredient.find_or_create_by(:name => i[:ingredient])
        self.ingredients_with_quantities << IngredientWithQuantity.new(:quantity => i[:quantity], :name => i[:ingredient])
      end
    end
  end
end
