class Recipe
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Paperclip

  before_save :save_ingredients

  slug :name

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
  accepts_nested_attributes_for :ingredients_with_quantities, :allow_destroy => true

  embeds_many :steps, :validate => false, :cascade_callbacks => true
  accepts_nested_attributes_for :steps, :allow_destroy => true, :reject_if => :all_blank

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true
  
  attr_accessible :name, :portion, :duration, :ingredients_with_quantities, :city, :country, :latitude, :longitude, :images, :images_attributes, :steps, :steps_attributes

  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    state :published do
      validates_presence_of :name, :portion, :duration, :city, :country, :latitude, :longitude
      validates_associated :steps
    end
  end

  def valid_ingredients_strings
    if ingredients_strings
      ingredients_strings.reject{ |ingredient_string| ingredient_string[:quantity].blank? && ingredient_string[:ingredient].blank? }
    else
      nil
    end
  end

  private
  def save_ingredients
    ingredients_with_quantities.each do |ingredient_with_quantity|
      ingredients << Ingredient.find_or_create_by(:name => ingredient_with_quantity.name)
    end
  end
end
