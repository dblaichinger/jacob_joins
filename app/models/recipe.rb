class Recipe
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paperclip
  #include Mongoid::Spacial::Document
  include Gmaps4rails::ActsAsGmappable
  
  acts_as_gmappable :validation => false, :check_process => false #:lat => :latitude, :lng => :longitude, :process_geocoding => false, :check_process => false, :validation => false

  before_save :save_ingredients#, :save_location

  slug :name

  field :name, :type => String
  field :portions, :type => Integer
  field :duration, :type => Integer
  field :city, :type => String
  field :country, :type => String
  field :latitude, :type => Float
  field :longitude, :type => Float
  #field :location, type: Array, spacial: {lat: :latitude, lng: :longitude, return_array: true }
  #field :location, :type => Array, :geo => true, :lat => :latitude, :lng => :longitude
  #geo_index :location
  #field :gmaps, :type => Boolean

  attr_accessible :name, :portions, :duration, :ingredients, :ingredients_with_quantities, :ingredients_with_quantities_attributes, :steps, :steps_attributes, :images, :images_attributes, :latitude, :longitude, :city, :country, :images_attributes, :user, :user_id
  attr_accessible :name, :portions, :duration, :ingredients, :ingredients_with_quantities, :ingredients_with_quantities_attributes, :steps, :steps_attributes, :images, :images_attributes, :latitude, :longitude, :city, :country, :images_attributes, :user, :state, :as => :admin

  index "ingredient_with_quantities.name"

  belongs_to :user

  has_and_belongs_to_many :ingredients

  embeds_many :ingredients_with_quantities
  accepts_nested_attributes_for :ingredients_with_quantities, :allow_destroy => true, :reject_if => :all_blank
  
  embeds_many :steps, :cascade_callbacks => true
  accepts_nested_attributes_for :steps, :allow_destroy => true, :reject_if => :all_blank

  embeds_many :images, :cascade_callbacks => true
  accepts_nested_attributes_for :images, :allow_destroy => true


  state_machine :initial => :draft do
    before_transition :draft => :published, :do => :publish_embedded_steps
    after_failure :on => :publish, :do => :unpublish_embedded_steps

    event :publish do
      transition :draft => :published
    end

    state :published do
      validates :name, :portions, :duration, :country, :latitude, :longitude, :presence => true
      validates_numericality_of :portions, :duration
      validates_associated :steps
    end

  end

  def self.search_by_ingredient(name)
    Recipe.where({"ingredients_with_quantities.name" => name, :state => "published"}).includes(:user)
  end

  #Methods for Gmaps4rails
  def gmaps4rails_address
   "#{self.city}, #{self.country}" 
  end

  def gmaps4rails_infowindow
    output = ""
    if self.images.present?
      #output << "#{image_tag self.images.attachment(:small)}"
      #output << "<img src='#{self.images.attachment(:small)}' />"
    end
    output += "<div class='recipe_marker_result'>"
    output += "<p class='infobox_recipe'><a href='/recipes/#{self.slug}' class='recipe_link'>#{self.name}</a></p>"
    unless self.user.nil?
      output += "<p class='infobox_author'> cooked by <em>#{self.user.firstname} #{self.user.shorten_lastname}</em>, #{self.city} </p>"
    end
    output += "<p class='infobox_duration'> Estimated cooking time: #{self.duration} minutes</p>"
    output += "</div>"
  end

  def gmaps4rails_marker_picture
  {
    "picture" => "/assets/google_marker_small.png",  # string,  mandatory
    "width" =>  30,          # integer, mandatory
    "height" => 50,          # integer, mandatory
    "marker_anchor" => nil,   # array,   facultative
    "shadow_picture" => nil,  # string,  facultative
    "shadow_width" => nil,    # string,  facultative
    "shadow_height" => nil,   # string,  facultative
    "shadow_anchor" => nil,   # string,  facultative
  }
  end

  def self.last_entries(count = 3)
    Recipe.where(:user.ne => "nil", :state => "published").order_by(:created_at => :desc).limit(count)
  end

  private
  def save_ingredients
    ingredients_with_quantities.each do |ingredient_with_quantity|
      ingredients << Ingredient.find_or_create_by(:name => ingredient_with_quantity.name) if ingredients.where(:name => ingredient_with_quantity.name).count == 0
    end
  end

  def publish_embedded_steps
    steps.all? { |step| step.publish }
  end

  def unpublish_embedded_steps
    steps.where(:state => "published").each {|step| step.unpublish}
  end

  def save_location
    self.location = {:lat => self.latitude, :lng => self.longitude}
  end
end
