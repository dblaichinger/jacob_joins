class Recipe
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paperclip

  before_save :save_ingredients

  slug :name

  field :name, :type => String
  field :portions, :type => Integer
  field :duration, :type => Integer
  field :city, :type => String
  field :country, :type => String
  field :latitude, :type => Float
  field :longitude, :type => Float

  belongs_to :user

  has_and_belongs_to_many :ingredients

  embeds_many :ingredients_with_quantities
  accepts_nested_attributes_for :ingredients_with_quantities, :allow_destroy => true, :reject_if => :all_blank

  embeds_many :steps, :validate => false, :cascade_callbacks => true
  accepts_nested_attributes_for :steps, :allow_destroy => true, :reject_if => :all_blank

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true
  
  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    state :published do
      validates_presence_of :name, :portions, :duration, :city, :country, :latitude, :longitude
      validates :portions, :duration, :numericality => { :only_integer => true }
      validates_associated :steps
    end
  end

  def formatted_portions
    portions > 6 ? "more than six" : portions
  end

  private
  def save_ingredients
    ingredients_with_quantities.each do |ingredient_with_quantity|
      ingredients << Ingredient.find_or_create_by(:name => ingredient_with_quantity.name) if ingredients.where(:name => ingredient_with_quantity.name).count == 0
    end
  end
end
